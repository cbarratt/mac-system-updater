#!/usr/bin/env ruby
APP_ROOT = File.dirname(__FILE__)
$:.unshift(File.join(APP_ROOT, 'lib') )

if Gem::Platform.local =~ /Darwin/i

  System::Update.new.perform
else
  puts  "\tThis program requires Mac OS X to run. \n\tPlease Use a Mac OSX machine."
end
