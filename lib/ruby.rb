class Ruby
  class << self
    def check_rubygems_version
      check_update_message('Rubygems')
      get_gem_json('rubygems-update')

      current = `gem -v`.delete!("\n")
      latest = @response['version']

      if Gem::Version.new(current) < Gem::Version.new(latest)
        system 'gem update --system'
      else
        puts "  - You currently have Rubygems #{current} installed which is the latest version.".colorize(:green)
      end

      break_output
    end

    def check_bundler_version
      check_update_message('Bundler')
      get_gem_json('bundler')

      current = `bundler -v`.delete!("Bundler version\n")
      latest = @response['version']

      if current.nil? || Gem::Version.new(current) < Gem::Version.new(latest)
        system 'gem install bundler'
      else
        puts "  - You currently have Bundler #{current} installed which is the latest version.".colorize(:green)
      end

      break_output
    end

    def get_gem_json(name)
      uri = URI("https://rubygems.org/api/v1/gems/#{name}.json")
      @response = Net::HTTP.get(uri)
      @response = JSON.parse(@response)
    end
  end
end
