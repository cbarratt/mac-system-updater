class Ruby
  def self.check_rubygems_version
    check_update_message('Rubygems')
    uri = URI('https://rubygems.org/api/v1/gems/rubygems-update.json')
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)

    current = %x(gem -v).delete!("\n")
    latest = response['version']
    if Gem::Version.new(current) < Gem::Version.new(latest)
      system 'gem update --system'
    else
      puts "#{Tty.green}  - You currently have Rubygems #{current} which is the latest version.#{Tty.reset}"
    end
    break_output
  end
end