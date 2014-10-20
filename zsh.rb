class ZSH
  def self.installed?
    File.exist? File.expand_path('~/.oh-my-zsh')
  end

  def self.update
    check_update_message('Oh My Zsh')

    Open3.popen3('env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh') do |stdin, stdout|
      output = stdout.read
      if output.include?('Current branch master is up to date')
        puts "#{Tty.green}  - Oh My Zsh already up to date.#{Tty.reset}"
      else
        puts '# Updating Oh My Zsh...'
        system 'env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh'
      end
    end
    break_output
  end
end