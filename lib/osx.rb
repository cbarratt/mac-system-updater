class OSX
  using StringExtensions

  class << self
    def intro
      puts <<-EOS.undent.colorize(:light_white)
      ##################
      # Mac OSX checks #
      ##################
      EOS
      break_output
    end

    def system_info
      cpu = %x(sysctl -n machdep.cpu.brand_string).delete!("\n")
      osx = %x(sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - -).delete!("\n")
      hostname = %x(scutil --get ComputerName).delete!("\n")
      ram = %x(sysctl -n hw.memsize | awk '{print $0/1073741824" GB"}').delete!("\n")
      ruby = %x(ruby -e 'puts RUBY_DESCRIPTION').delete!("\n")

      break_output

      puts <<-EOS.undent.colorize(:light_white).bold
        System information:
          - CPU:   #{cpu}
          - OSX:   #{osx}
          - Host:  #{hostname}
          - RAM:   #{ram}
          - Ruby:  #{ruby}
      EOS

      break_output
    end

    def check_mac_store_updates
      check_update_message('Mac App Store')
      if run?
        Open3.popen3('softwareupdate -l') do |stdin, stdout, stderr|
          output = stdout.read
          error = stderr.read
          updates = output.split(/\r\n|\r|\n/, 5).last
          if output.include?('Software Update found')
            puts updates
            # %x(softwareupdate -i -a) - Commented out as we dont want to auto update yet.
          end
          puts '  - No new software updates available.' if error.include?('No new software available')
        end
      else
        puts '  - Skipped.'.colorize(:red)
      end
      break_output
    end

    def repair_disk_permissions
      puts '# Repairing OSX disk permissions'
      if run?
        Open3.popen2e('diskutil repairPermissions /') do |stdin, stdout_err, wait_thr|
          while line = stdout_err.gets
            puts line.delete!("\n").indent(4).colorize(:green)
          end

          exit_status = wait_thr.value
          unless exit_status.success?
            abort "FAILED !!! #{cmd}"
          end
        end
      else
        puts '  - Skipped.'.colorize(:red)
      end
    end
  end
end