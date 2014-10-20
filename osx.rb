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
    break_output
  end

  def self.repair_disk_permissions
    puts '# Repairing OSX disk permissions'
    if run?
      begin
        PTY.spawn('diskutil repairPermissions /') do |stdin, stdout, stderr, thread|
          begin
            stdin.each { |line| print line }
          rescue Errno::EIO
          end
        end
      rescue PTY::ChildExited
        puts 'The child process exited!'
      end
    else
      puts "#{Tty.red}  - Skipped.#{Tty.reset}"
    end
  end
end
