#!/usr/bin/env ruby

require 'open3'
require 'pty'
require 'pry'
require 'json'
require 'net/http'

module System
  class Update
    def perform
      system_info
      check_rubygems_version

      if File.exist?('/usr/local/bin/brew')
        update_brew_packages
        cleanup_homebrew
      end

      if File.exist? File.expand_path('~/.rvm')
        update_rvm
        cleanup_rvm
      end

      update_oh_my_zsh
      update_rbenv if File.exist? File.expand_path('~/.rbenv')

      puts '##################'
      puts '# Mac OSX checks #'
      puts '##################'
      break_output
      check_mac_store_updates
      repair_disk_permissions
    end

    def break_output
      puts ''
    end

    def check_rubygems_version
      puts '# Checking Rubygems version is up to date...'
      uri = URI('https://rubygems.org/api/v1/gems/rubygems-update.json')
      response = Net::HTTP.get(uri)
      response = JSON.parse(response)

      current = %x(gem -v).delete!("\n")
      latest = response['version']
      if Gem::Version.new(current) < Gem::Version.new(latest)
        system 'gem update --system'
      else
        puts "  - You currently have Rubygems #{current} which is the latest version."
      end
      break_output
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
      puts '  - Ruby: ' + %x(ruby -e 'puts RUBY_DESCRIPTION')
      break_output
    end

    def run?
      puts '  - Do you want to perform this action? (y/n)'
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

    def cleanup_rvm
      puts '# Cleanup of RVM'
      if run?
        begin
          PTY.spawn('rvm cleanup all') do |stdin, stdout, stderr, thread|
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
      break_output
    end

    def cleanup_homebrew
      puts '# Cleanup of Homebrew packages'
      if run?
        Open3.popen3('brew cleanup') do |stdin, stdout|
          output = stdout.read
          if output.empty?
            puts '  - Old Homebrew packages already cleaned.'
          else
            puts '  - Cleaned Homebrew packages.'
          end
        end
      else
        puts '  - Skipped.'
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
