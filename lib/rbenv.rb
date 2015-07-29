class Rbenv
  class << self
    def installed?
      File.exist? File.expand_path('~/.rbenv')
    end

    def update
      if git_installed?
        check_update_message('rbenv (git based install)')
        update_git_based
      else
        check_update_message('rbenv (brew based install)')
        update_brew_based
      end

      break_output
    end

    def update_git_based
      Open3.capture2e('cd ~/.rbenv && git pull && cd plugins/ruby-build/ && git pull')
      puts '  - rbenv updated.'.colorize(:green)
    end

    def update_brew_based
      result, _cmd = Open3.capture2e('brew upgrade rbenv ruby-build')

      puts result.indent(4).colorize(:light_cyan)
      puts '  - rbenv updated.'.colorize(:green)
    end

    def git_installed?
      File.exist? File.expand_path('~/.rbenv/.git')
    end
  end
end
