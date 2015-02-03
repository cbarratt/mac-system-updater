class Brew
  class << self
    def installed?
      File.exist?('/usr/local/bin/brew')
    end

    def cleanup
      puts 'Cleanup of Homebrew packages'.colorize(:light_white).bold
      if run?
        Open3.popen3('brew cleanup') do |stdin, stdout|
          output = stdout.read
          if output.empty?
            puts '  - Homebrew packages already clean.'.colorize(:green)
          else
            puts '  - Cleaned Homebrew packages.'.colorize(:green)
          end
        end
      else
        puts '  - Skipped.'.colorize(:red)
      end
      break_output
    end

    def update
      check_update_message('Homebrew')
      if %x(brew update | grep Already)
        puts '  - Homebrew packages already up to date.'.colorize(:green)
      else
        puts '  - Updating Homebrew packages...'.colorize(:green)
        system 'brew update'
      end
      break_output
    end
  end
end
