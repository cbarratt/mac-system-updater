class OSX
  def self.intro
    puts <<-EOS.undent
    #{Tty.white}##################
    # Mac OSX checks #
    ###################{Tty.reset}
    EOS
    break_output
  end

  def self.system_info
    cpu = %x(sysctl -n machdep.cpu.brand_string).delete!("\n")
    osx = %x(sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - -).delete!("\n")
    hostname = %x(scutil --get ComputerName).delete!("\n")
    ram = %x(sysctl -n hw.memsize | awk '{print $0/1073741824" GB"}').delete!("\n")
    ip = %x(ipconfig getifaddr en0).delete!("\n")
    ruby = %x(ruby -e 'puts RUBY_DESCRIPTION').delete!("\n")

    puts <<-EOS.undent
      #{Tty.white}# System information:#{Tty.reset}
        - CPU:   #{cpu}
        - OSX:   #{osx}
        - Host:  #{hostname}
        - RAM:   #{ram}
        - IP:    #{ip}
        - Ruby:  #{ruby}
    EOS

    break_output
  end

  def self.check_mac_store_updates
    check_update_message('Mac App Store')
    if run?
      Open3.popen3('softwareupdate -l') do |stdin, stdout, stderr|
        output = stdout.read
        error = stderr.read
        updates = output.split(/\r\n|\r|\n/, 5).last
        if output.include?('Software Update found')
          puts updates
          %x(softwareupdate -i -a)
        end
        puts "#{Tty.green}  - No new software updates available.#{Tty.reset}" if error.include?('No new software available')
      end
    else
      puts "#{Tty.red}  - Skipped.#{Tty.reset}"
    end
    break_output
  end

  def self.repair_disk_permissions
    puts '# Repairing OSX disk permissions'
    if run?
      Open3.popen2e('diskutil repairPermissions /') do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          puts "#{Tty.green}#{line.delete!("\n").indent(4)}#{Tty.reset}"
        end

        exit_status = wait_thr.value
        unless exit_status.success?
          abort "FAILED !!! #{cmd}"
        end
      end
    else
      puts "#{Tty.red}  - Skipped.#{Tty.reset}"
    end
  end
end
