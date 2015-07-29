class ZSH
  class << self
    def installed?
      file_or_folder_exists?('/.oh-my-zsh')
    end

    def update
      check_update_message('Oh My Zsh')

      result, _cmd = Open3.capture2e('env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh')

      if result.include?('Current branch master is up to date')
        puts '  - Oh My Zsh already up to date.'.colorize(:green)
      else
        puts '  - Updated Oh My Zsh...'.colorize(:green)
      end

      break_output
    end
  end
end
