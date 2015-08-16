class Pretzo
  class << self
    def installed?
      file_or_folder_exists?('/.zprezto')
    end

    def update
      check_update_message('Pretzo')

      result, _cmd = Open3.capture2e('cd ~/.zprezto && git pull && git submodule update --init --recursive')

      if result.include?('Already up-to-date')
        puts '  - Pretzo already up to date.'.colorize(:green)
      else
        puts '  - Updated Pretzo...'.colorize(:green)
      end

      break_output
    end
  end
end
