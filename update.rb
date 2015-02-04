#!/usr/bin/env ruby
APP_ROOT = File.dirname(__FILE__)
$:.unshift(File.join(APP_ROOT, 'lib') )


os = Gem::Platform.local

if os.to_s =~ /[darwin]/i
	require 'system'
  System::Update.new.perform
else
  puts  "\tThis program requires Mac OS X to run. \n\tPlease Use a Mac OSX machine."
end

