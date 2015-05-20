class Rbenv
  class << self
    def installed?
      File.exist? File.expand_path('~/.rbenv')
    end

    def update
      check_update_message('rbenv')
      Open3.popen3('cd ~/.rbenv && git pull && cd plugins/ruby-build/ && git pull') do |stdin, stdout, stderr, thread|
        puts '  - rbenv updated.'.colorize(:green)
      end
      break_output
    end
  end
end
