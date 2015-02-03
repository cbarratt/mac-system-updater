module StringExtensions
  refine String do
    def undent
      gsub(/^.{#{(slice(/^ +/) || '').length}}/, '')
    end

    alias_method :undent_________________________________________________________72, :undent
  end
end

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
  puts "Checking #{app} for updates...".colorize(:light_white).bold
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
  if System::Update::AUTO_RUN == 'yes'
    return true
  else
    puts '  - Do you want to perform this action? (y/n)'
    yes_or_no
  end
end
