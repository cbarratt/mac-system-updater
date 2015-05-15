# OSX Update script

[![Join the chat at https://gitter.im/cbarratt/mac_system_update](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cbarratt/mac_system_update?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/t0nyshier/mac_system_update?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

### Compatability

* Ruby 2.1+ (this is due to Refinements changing a lot)

The script will check and update any of the following if installed:

* Rubygems gem
* Bundler gem
* OhMyZsh (performs git pull)
* Homebrew (performs brew update - NOT upgrade, there's a future feature in there to be done for upgrading)
* RVM (rvm get stable)
* rbenv (performs git pull)
* Mac App Store (Lists out all available MAS updates, currently doesn't have the functionality to install)

It also has the ability to cleanup old versions of Homebrew installed software and RVM sources/gems.

![ScreenShot](http://files.bolser.co.uk/files/Screen%20Shot%202014-10-23%20at%2016.40.25.png)

# Usage

You can automatically run all checks and updates by passing in `yes` as a command line argument, for example:

```bash
./update.rb yes
```

```bash
git clone git@github.com:cbarratt/mac_system_update.git && cd mac_system_update && ./update.rb
```
