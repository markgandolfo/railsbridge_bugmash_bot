require 'rubygems'

begin
  require 'uri'
  require 'addressable/uri'

  module URI
    def decode(*args)
      Addressable::URI.decode(*args)
    end

    def escape(*args)
      Addressable::URI.escape(*args)
    end

    def parse(*args)
      Addressable::URI.parse(*args)
    end
  end
rescue LoadError => e
  puts "Install the Addressable gem (with dependencies) to support accounts with subdomains."
  puts "# sudo gem install addressable --development"
  puts e.message
end


require 'activesupport'
require 'activeresource'



module Lighthouse
  class Error < StandardError; end
  class << self
    attr_accessor :email, :password, :host_format, :domain_format, :protocol, :port
    attr_reader :account, :token

    # Sets the account name, and updates all the resources with the new domain.
    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format % name, ":#{port}"])
      end
      @account = name
    end

    # Sets up basic authentication credentials for all the resources.
    def authenticate(email, password)
      @email    = email
      @password = password
    end

    # Sets the API token for all the resources.
    def token=(value)
      resources.each do |klass|
        
        klass.headers['X-LighthouseToken'] = value
      end
      @token = value
    end

    def resources
      @resources ||= []
    end
  end
  
  self.host_format   = '%s://%s%s'
  self.domain_format = '%s.lighthouseapp.com'
  self.protocol      = 'http'
  self.port          = ''

  
  class Change < Array; end


end


Dir[File.join(File.dirname(__FILE__), 'lighthouse/*.rb')].sort.each { |f| require f }

module ActiveResource
  class Connection
    private
      def authorization_header
        (Lighthouse.email || Lighthouse.password ? { 'Authorization' => 'Basic ' + ["#{Lighthouse.email}:#{Lighthouse.password}"].pack('m').delete("\r\n") } : {})
      end
  end
end
