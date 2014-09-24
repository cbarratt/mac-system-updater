#!/usr/bin/env ruby

require 'open3'
require 'pry'

module System
  class Update
    def perform
      system_info
      break_output
      update_brew_packages
      break_output
      update_oh_my_zsh
      break_output
      update_ruby_manager
      break_output
      check_mac_store_updates
    end

    def break_output
      puts ''
    end

    def check_update_message(app)
      puts "# Checking #{app} for updates..."
    end

    def system_info
      puts '# System information:'
      puts '  - CPU: ' + %x{sysctl -n machdep.cpu.brand_string}
      puts '  - OSX: ' + %x{sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - -}
      puts '  - Host: ' + %x{scutil --get ComputerName}
      puts '  - RAM: ' + %x{sysctl -n hw.memsize | awk '{print $0/1073741824" GB RAM"}'}
    end

    def check_mac_store_updates
      check_update_message('Mac App Store')
      Open3.popen3('softwareupdate -l') do |stdin, stdout, stderr, thread|
        output = stdout.read
        error = stderr.read
        puts '  - No new software updates available.' if error.include?('No new software available')
      end
    end

    def update_ruby_manager
      if %x{~/.rvm/bin/rvm-prompt}
        check_update_message('RVM')
        Open3.popen3('rvm get stable') do |stdin, stdout, stderr, thread|
          output = stdout.read
          puts '  - RVM updated.' if output.include?('RVM reloaded')
        end
      end
    end

    def update_oh_my_zsh
      check_update_message('Oh My Zsh')

      Open3.popen3('env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh') do |stdin, stdout, stderr, thread|
        output = stdout.read
        if output.include?('Current branch master is up to date')
          puts '  - Oh My Zsh already up to date.'
        else
          puts '# Updating Oh My Zsh...'
          system 'env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh'
        end
      end
    end

    def update_brew_packages
      check_update_message('Homebrew')
      if %x{brew update | grep Already}
        puts '  - Homebrew packages already up to date.'
      else
        puts '# Updating Homebrew packages...'
        system 'brew update'
      end
    end
  end
end

System::Update.new.perform
