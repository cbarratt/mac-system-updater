OSX Update script
=================

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/t0nyshier/mac_system_update?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# What does it do?

The script will check and update any of the following if installed:

* Rubygems
* Bundler
* OhMyZsh
* Homebrew
* RVM
* rbenv
* Mac App Store

It also has the ability to cleanup old versions of Homebrew installed software and RVM sources/gems.

![ScreenShot](http://files.bolser.co.uk/files/Screen%20Shot%202014-10-23%20at%2016.40.25.png)

Usage
=================

You can automatically run all checks & updates by passing in yes as a command line argument, for example:

```./update.rb yes```

git clone git@github.com:cbarratt/mac_system_update.git && cd mac_system_update && ./update.rb

