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
  puts "| Checking #{app} for updates...".bold
end

def cleanup_message(app)
  puts "| Cleaning up #{app}".bold
end

def break_output
  puts ''
end

def yes_or_no
  str = gets.chomp

  if str == 'y'
    puts '  - Performing...'.colorize(:light_cyan)
    return true
  elsif str == 'n'
    return false
  else
    raise 'Invalid choice. Options are "y" or "n"'
  end
end

def run?
  return true if System::Update::AUTO_RUN == '--auto'

  print "  - Do you want to perform this action? (y/n) "
  yes_or_no
end
