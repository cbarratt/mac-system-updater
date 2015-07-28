require 'dev_osx_updater/version'

class OSX
  using StringExtensions

  class << self
    def intro
      puts <<-EOS.undent
      -------------------
      # OSX Maintenance #
      -------------------
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

      puts <<-EOS.undent.bold
        Mac OSX updater version: #{DevOsxUpdater::VERSION}
        ------------------------------

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
          end
          puts '  - No new software updates available.' if error.include?('No new software available')
        end
      else
        puts '  - Skipped.'.colorize(:red)
      end
      break_output
    end

    def repair_disk_permissions
      puts '| Repairing OSX disk permissions...'.bold
      if run?
        Open3.popen2e('diskutil repairPermissions /') do |stdin, stdout_err, wait_thr|
          while line = stdout_err.gets
            puts line.delete!("\n").indent(4).colorize(:green)
            break_output
          end

          exit_status = wait_thr.value
          unless exit_status.success?
            abort "FAILED !!! #{cmd}"
          end
        end
      else
        puts '  - Skipped.'.colorize(:red)
        break_output
      end
    end
  end
end
