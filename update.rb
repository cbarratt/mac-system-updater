#!/usr/bin/env ruby

require 'open3'
require 'pty'

module System
  class Update
    def perform
      system_info
      update_brew_packages
      update_oh_my_zsh
      update_rvm if File.exist? File.expand_path('~/.rvm')
      update_rbenv if File.exist? File.expand_path('~/.rbenv')
      check_mac_store_updates
      repair_disk_permissions
    end

    def break_output
      puts ''
    end

    def check_update_message(app)
      puts "# Checking #{app} for updates..."
    end

    def system_info
      puts '# System information:'
      puts '  - CPU: '  + %x(sysctl -n machdep.cpu.brand_string)
      puts '  - OSX: '  + %x(sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - -)
      puts '  - Host: ' + %x(scutil --get ComputerName)
      puts '  - RAM: '  + %x(sysctl -n hw.memsize | awk '{print $0/1073741824" GB"}')
      puts '  - IP: '   + %x(ipconfig getifaddr en0)
      break_output
    end

    def run?
      puts 'Do you want to perform this action? (y/n)'
      answer = gets.chomp
      if answer == 'y'
        true
      else
        false
      end
    end

    def repair_disk_permissions
      puts '# Repairing OSX disk permissions'
      if run?
        begin
          PTY.spawn('diskutil repairPermissions /') do |stdin, stdout, stderr, thread|
            begin
              stdin.each { |line| print line }
            rescue Errno::EIO
            end
          end
        rescue PTY::ChildExited
          puts 'The child process exited!'
        end
      else
        puts '  - Skipped.'
      end
    end

    def check_mac_store_updates
      check_update_message('Mac App Store')
      Open3.popen3('softwareupdate -l') do |stdin, stdout, stderr|
        output = stdout.read
        error = stderr.read
        updates = output.split(/\r\n|\r|\n/, 5).last
        if output.include?('Software Update found')
          puts updates
          %x(softwareupdate -i -a)
        end
        puts '  - No new software updates available.' if error.include?('No new software available')
      end
      break_output
    end

    def update_rvm
      check_update_message('RVM')
      Open3.popen3('rvm get stable') do |stdin, stdout|
        output = stdout.read
        puts '  - RVM updated.' if output.include?('RVM reloaded')
      end
      break_output
    end

    def update_rbenv
      check_update_message('rbenv')
      Open3.popen3('cd ~/.rbenv && git pull && cd cd plugins/ruby-build/ && git pull') do |stdin, stdout, stderr, thread|
        puts '  - rbenv updated.'
      end
      break_output
    end

    def update_oh_my_zsh
      if File.exist? File.expand_path('~/.oh-my-zsh')
        check_update_message('Oh My Zsh')

        Open3.popen3('env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh') do |stdin, stdout|
          output = stdout.read
          if output.include?('Current branch master is up to date')
            puts '  - Oh My Zsh already up to date.'
          else
            puts '# Updating Oh My Zsh...'
            system 'env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh'
          end
        end
      else
        puts '# Oh My Zsh is not installed. Skipped.'
      end
      break_output
    end

    def update_brew_packages
      check_update_message('Homebrew')
      if %x(brew update | grep Already)
        puts '  - Homebrew packages already up to date.'
      else
        puts '# Updating Homebrew packages...'
        system 'brew update'
      end
      break_output
    end
  end
end

System::Update.new.perform
