require 'colorize'
require 'open3'
require 'pty'
require 'json'
require 'net/http'

require 'utility'
require 'rvm'
require 'brew'
require 'ruby'
require 'osx'
require 'zsh'
require 'pretzo'
require 'rbenv'

module System
  class Update
    AUTO_RUN = ARGV[0]

    def perform
      OSX.system_info
      ruby

      ZSH.update if ZSH.installed?
      Pretzo.update if Pretzo.installed?
      Rbenv.update if Rbenv.installed?

      brew if Brew.installed?
      rvm if RVM.installed?
      osx
    end

    def ruby
      Ruby.check_rubygems_version
      Ruby.check_bundler_version
    end

    def brew
      Brew.update
      Brew.cleanup
    end

    def rvm
      RVM.update
      RVM.cleanup
    end

    def osx
      OSX.intro
      OSX.check_mac_store_updates
    end
  end
end
