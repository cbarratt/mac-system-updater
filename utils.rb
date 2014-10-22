String.class_eval do
  def indent(count, char = ' ')
    gsub(/([^\n]*)(\n|$)/) do |match|
      last_iteration = ($1 == '' && $2 == '')
      line = ''
      line << (char * count) unless last_iteration
      line << $1
      line << $2
      line
    end
  end
end

def file_or_folder_exists?(file)
  home = ENV['HOME']
  path = "#{home}" "#{file}"
  File.exist?(path)
end

def check_update_message(app)
  puts "#{Tty.white}# Checking #{app} for updates...#{Tty.reset}"
end

def break_output
  puts ''
end

def yes_or_no
  begin
    system('stty raw -echo')
    str = STDIN.getc
  ensure
    system('stty -raw echo')
  end
  if str == 'y'
    puts '  - Performing...'
    return true
  elsif str == 'n'
    return false
  else
    raise 'Invalid choice. Options are "y" or "n"'
  end
end

def run?
  puts '  - Do you want to perform this action? (y/n)'
  yes_or_no
end

class Tty
  class << self
    def blue; bold 34; end
    def white; bold 39; end
    def red; bold 31; end
    def yellow; underline 33; end
    def reset; escape 0; end
    def em; underline 39; end
    def green; color 32; end
    def gray; bold 30; end

    private

    def color n
      escape "0;#{n}"
    end

    def bold n
      escape "1;#{n}"
    end

    def underline n
      escape "4;#{n}"
    end

    def escape n
      "\033[#{n}m" if $stdout.tty?
    end
  end
end

class String
  def undent
    gsub(/^.{#{(slice(/^ +/) || '').length}}/, '')
  end
  # eg:
  #   if foo then <<-EOS.undent_________________________________________________________72
  #               Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
  #               eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
  #               minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
  #               ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
  #               voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur
  #               sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
  #               mollit anim id est laborum.
  #               EOS
  alias_method :undent_________________________________________________________72, :undent
end
