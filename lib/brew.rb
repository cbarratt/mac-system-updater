class Brew
  class << self
    def installed?
      File.exist?('/usr/local/bin/brew')
    end

    def cleanup
      cleanup_message('Homebrew packages')

      if run?
        result, _cmd = Open3.capture2e('brew cleanup')

        puts '  - Homebrew packages already clean.'.colorize(:green) if result.empty?
        puts '  - Cleaned Homebrew packages.'.colorize(:green) unless result.empty?
      else
        puts '  - Skipped.'.colorize(:red)
      end

      break_output
    end

    def info
      `brew info`.delete!("\n")
    end

    def update
      check_update_message('Homebrew')

      result, _cmd = Open3.capture2e('brew update')

      puts '  - Homebrew packages already up to date.'.colorize(:green) if result.include?('Already up-to-date')
      puts '  - Homebrew packages updated.'.colorize(:green) unless result.include?('Already up-to-date')

      break_output
    end
  end
end
