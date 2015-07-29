class RVM
  class << self
    def installed?
      File.exist? File.expand_path('~/.rvm')
    end

    def update
      check_update_message('RVM')

      result, _cmd = Open3.capture2e('rvm get stable')
      puts '  - RVM updated.'.colorize(:green) if result.include?('RVM reloaded')

      break_output
    end

    def cleanup
      cleanup_message('RVM')
      if run?
        begin
          PTY.spawn('rvm cleanup all') do |stdin, _stdout, _stderr, _thread|
            begin
              stdin.each { |line| print line.indent(2) }
            rescue Errno::EIO
            end
          end
        rescue PTY::ChildExited
          puts 'The child process exited!'
        end
      else
        puts '  - Skipped.'.colorize(:red)
      end
      break_output
    end
  end
end
