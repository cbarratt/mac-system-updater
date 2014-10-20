class Rbenv
  def self.installed?
    File.exist? File.expand_path('~/.rbenv')
  end

  def self.update
    check_update_message('rbenv')
    Open3.popen3('cd ~/.rbenv && git pull && cd cd plugins/ruby-build/ && git pull') do |stdin, stdout, stderr, thread|
      puts '  - rbenv updated.'
    end
    break_output
  end
end