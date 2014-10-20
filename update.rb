#!/usr/bin/env ruby

require_relative 'utils'
require_relative 'rvm'
require_relative 'brew'
require_relative 'ruby'
require_relative 'osx'
require_relative 'zsh'
require_relative 'rbenv'

require 'open3'
require 'pty'
require 'pry'
require 'json'
require 'net/http'

module System
  class Update
    def perform
      OSX.system_info
      Ruby.check_rubygems_version

      if Brew.installed?
        Brew.update
        Brew.cleanup
      end

      if RVM.installed?
        RVM.update
        RVM.cleanup
      end

      ZSH.update if ZSH.installed?
      Rbenv.update if Rbenv.installed?

      OSX.intro
      OSX.check_mac_store_updates
      OSX.repair_disk_permissions
    end
  end
end

System::Update.new.perform
