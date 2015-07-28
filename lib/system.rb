# Gems
require 'colorize'
require 'open3'
require 'pty'
require 'json'
require 'net/http'

# Local files
require 'utility'
require 'rvm'
require 'brew'
require 'ruby'
require 'osx'
require 'zsh'
require 'rbenv'

module System
  class Update
    AUTO_RUN = ARGV[0]

    def perform
      OSX.system_info
      Ruby.check_rubygems_version
      Ruby.check_bundler_version

      ZSH.update if ZSH.installed?
      Rbenv.update if Rbenv.installed?

      if Brew.installed?
        Brew.update
        Brew.cleanup
      end

      if RVM.installed?
        RVM.update
        RVM.cleanup
      end

      OSX.intro
      OSX.check_mac_store_updates
      OSX.repair_disk_permissions
    end
  end
end
