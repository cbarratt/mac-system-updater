class RVM
  class << self
    def installed?
      File.exist? File.expand_path('~/.rvm')
    end

    def update
    check_update_message('RVM')
      Open3.popen3('rvm get stable') do |stdin, stdout|
        output = stdout.read
        puts "#{Tty.green}  - RVM updated.#{Tty.reset}" if output.include?('RVM reloaded')
      end
      break_output
    end

    def cleanup
      puts "#{Tty.white}# Cleanup of RVM#{Tty.reset}"
      if run?
        begin
          PTY.spawn('rvm cleanup all') do |stdin, stdout, stderr, thread|
            begin
              stdin.each { |line| print line.indent(4) }
            rescue Errno::EIO
            end
          end
        rescue PTY::ChildExited
          puts 'The child process exited!'
        end
      else
        puts "#{Tty.red}  - Skipped.#{Tty.reset}"
      end
      break_output
    end
  end
end
