require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lighthouse'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['HOME'] = File.dirname(__FILE__)
require 'activerecord'
require 'lighthouse'
Dir[File.join(File.dirname(__FILE__), '..', 'models', '*')].each { |f| require f }

# Do not allow connections, stub out all returned data.
FakeWeb.allow_net_connect = false
Lighthouse.account = "rails"

def stub_file(*path)
  File.join(File.dirname(__FILE__), "stubs", path)
end


def fake_everything
  { 
    "projects.xml" => stub_file("projects", "projects.xml"),
    "projects/8994.xml" => stub_file("projects", "8994.xml"),
    "projects/8994/tickets.xml" => stub_file("projects", "8994", "tickets", "tickets.xml"),
    "projects/8994/tags.xml" => stub_file("projects", "8994", "tags.xml"),
    "projects/8994/tickets.xml?q=tagged%3A%22zone%22" => stub_file("projects", "8994", "tagged_with_zone.xml")
  }.each do |req, stub|
    FakeWeb.register_uri(:get, "http://rails.lighthouseapp.com/#{req}", :body => File.read(stub))
  end
  
  {
    "projects.xml" => stub_file("projects", "projects.xml")
  }.each do |req, stub|
    # FakeWeb.register_uri(:post, "http://rails.")/
  end

end


class Test::Unit::TestCase
  
end
