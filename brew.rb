class Brew
  def self.installed?
    File.exist?('/usr/local/bin/brew')
  end

  def self.cleanup
    puts "#{Tty.white}# Cleanup of Homebrew packages#{Tty.reset}"
    if run?
      Open3.popen3('brew cleanup') do |stdin, stdout|
        output = stdout.read
        if output.empty?
          puts "#{Tty.green}  - Homebrew packages already clean.#{Tty.reset}"
        else
          puts "#{Tty.green}  - Cleaned Homebrew packages.#{Tty.reset}"
        end
      end
    else
      puts "#{Tty.red}  - Skipped.#{Tty.reset}"
    end
    break_output
  end

  def self.update
    check_update_message('Homebrew')
    if %x(brew update | grep Already)
      puts "#{Tty.green}  - Homebrew packages already up to date.#{Tty.reset}"
    else
      puts '# Updating Homebrew packages...'
      system 'brew update'
    end
    break_output
  end
end
