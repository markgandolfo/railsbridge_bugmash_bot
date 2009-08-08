require 'rubygems'
require 'mechanize'
require 'activerecord'

ActiveRecord::Base.establish_connection(YAML.load_file("config/seasons/masher/database.yml")["bug_masher"])
Dir["models/*.rb"].each { |f| require f }

a = WWW::Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

a.get('http://wiki.railsbridge.org/login') do |page|
  user_page = page.form_with(:action => '/login') do |login|
    password = File.read("password")
    login.field_with(:name => "username").value = "bugmasher"
    login.field_with(:name => "password").value = password.strip!
  end.submit
end


res = a.get("http://wiki.railsbridge.org/projects/railsbridge/wiki/BugMashStats/edit") do |page|
  wiki_page = page.form_with(:action => "/projects/railsbridge/wiki/BugMashStats/edit") do |wiki|
    value = ""
    
    for ticket in Ticket.all
      value << "\nh2. ##{ticket.number} #{"- " + ticket.title if ticket.title}\n\n"
      for people in ticket.people_tickets
        if people.state == "working"
          value << "* #{people.person.name}\n"
        else
          value << "* -#{people.person.name}-\n"
        end
      end
    end
    
    wiki.field_with(:name => "content[text]").value = value
  end.submit
end