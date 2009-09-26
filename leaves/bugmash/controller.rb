# Controller for the bugmash leaf.
require File.join(File.expand_path(File.dirname(__FILE__)), 'lighthouse', 'lighthouse')

Lighthouse.account = 'rails'
Lighthouse.email = 'lighthouse@bugmash.com'
Lighthouse.password = 'p6UJfIe6mW'
Lighthouse::Base.logger = Logger.new("lighthouse.log")
Lighthouse_Project = 8994
class Controller < Autumn::Leaf
    
  # Typing "!about" displays some basic information about this leaf.
  def about_command(stem, sender, reply_to, msg)
    
    stem.message "You can use me to keep track of lighthouse tickets, this will not update lighthouse, but only use it as a reference"
    stem.message ""
    stem.message "!status 1 - who is working on the ticket"
    stem.message "!working 1 - will assign you to the ticket"
    stem.message "!stopworking 1 - will unassign you from the ticket"
    stem.message "!gimme - Will give you a ticket that is not being worked on"
    return
  end
  
  def authorized?(name)
    ["radar", "mark[oz]"].include?(name.downcase)
  end
  
  def go_command(stem, sender, reply_to, msg)
    join_channel(msg) if authorized?(sender[:nick])
  end

  def leave_command(stem, sender, reply_to, msg)
    leave_channel(msg) if authorized?(sender[:nick])
  end
  
  # 
  # Check the status of a ticket
  #
  # !status TicketNumber
  #
  # Example:
  # !status 123
  #   
  #	https://rails.lighthouseapp.com/projects/8994/tickets/1234 is not flagged for this bugmash
  # https://rails.lighthouseapp.com/projects/8994/tickets/1234 is available for bugmashing
  # Would *love* it if could parse details of the ticket and tell us that it was waiting for confirmation, waiting for a failing test, waiting for a patch
  #	https://rails.lighthouseapp.com/projects/8994/tickets/1234 is being worked on by mark[oz] and Radar
  # (there's no reason we can't have multiple people looking at the same ticket - I don't want us to be a firm traffic cop)
  #
  def status_command(stem, sender, reply_to, msg)
    # Get Status Message
    if msg.nil?
      stem.message "Must specify a ticket ID", reply_to
      return false
    end
    if !Ticket.bug_mashable?(msg.to_i)
      stem.message 'This ticket is not bug mashable or is not a valid ticket, please try another', reply_to
      return false
    end

    # If we're here, it means the ticket is a valid bug masher ticket. 
    ticket = Ticket.find(:first, :conditions => { :number => msg })
    if ticket
      person_tickets = PeopleTicket.find_all_by_ticket_id(ticket.id)
    
      unless person_tickets.empty?
        returned_string = person_tickets.map { |pt| pt.person.name }.join(", ")
        is_or_are = person_tickets.size > 1 ? "are" : "is"
        stem.message returned_string + " #{is_or_are} working on ticket https://rails.lighthouseapp.com/projects/" + Lighthouse_Project.to_s + '/tickets/' + msg.to_s, reply_to
      else
        stem.message 'nobody is working on ticket https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s, reply_to
      end
    
    else
      ticket = Ticket.create(:number => msg.to_i)
      stem.message 'nobody is working on ticket https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s, reply_to
    end
    return
  end

  
  # 
  # Tell the world your working on ticket number, X
  #
  # !working TicketNumber
  #
  # Example:
  # !working 123
  # 
  def working_command(stem, sender, reply_to, msg)
    
    if Ticket.bug_mashable? msg.to_i
        
      # Does person exist? If not create them
      person = Person.find_or_create_by_name(sender[:nick])
    
      # Does the ticket exist? If not, create it
      ticket = Ticket.find_by_number(msg)
      ticket ||= Ticket.create_ticket(Ticket.from_lighthouseapp(msg))
    
      # Add the person/ticket relationship.
      pt = PeopleTicket.find_by_ticket_id_and_person_id(ticket.id, person.id)

      if !pt.nil?
        stem.message sender[:nick] + ' is already working on ' + 'https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s, reply_to
      else
        pt = PeopleTicket.create(:ticket_id => ticket.id, :person_id => person.id, :state => 'working')
        stem.message sender[:nick] + ' is now working on ' + 'https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s, reply_to
      end
    else
      stem.message 'This ticket is not bug mashable or is not a valid ticket, please try another', reply_to
      return false
    end
    return
  end
  
  alias_method :work_command, :working_command
  
  def me_command(stem, sender, reply_to, msg)
    person = Person.find_by_name(sender[:nick])
    stem.message("I do not know who you are!", sender[:nick]) and return if person.nil?
    tickets = PeopleTicket.find_all_by_person_id_and_state(person.id, "working")
    stem.message "You are working on #{tickets.size} " + (tickets.size > 1 || tickets.size == 0 ? "tickets" : "ticket"), sender[:nick]
    for ticket in tickets
      stem.message "##{ticket.ticket.number} - #{ticket.ticket.title}", sender[:nick]
    end
  end
   #  Commands currently broken
   # def review_command(stem, sender, reply_to, msg)
   #   ticket = Lighthouse::Ticket.find(msg, :params => { :q => %{tagged:"bugmash"}, :project_id => Lighthouse_Project } )
   #   if ticket
   #     ticket.tags << "bugmash-review"
   #     ticket.save_with_tags
   #     stem.message "Ticket #{msg} has now been marked for bugmash review."
   #   else
   #     stem.message "Couldn't find Ticket ##{msg}"
   #   end
   # end
   # 
   # def unreview_command(stem, sender, reply_to, msg)
   #   ticket = Lighthouse::Ticket.find(msg, :params => { :q => %{tagged:"bugmash"}, :project_id => Lighthouse_Project } )
   #   if ticket
   #     ticket.tags -= "bugmash-review"
   #     ticket.save_with_tags
   #     stem.message "Ticket #{msg} has now been unmarked for bugmash review."
   #   else
   #     stem.message "Couldn't find Ticket ##{msg}"
   #   end
   # end
  
  # Stop working on a ticket
  def stopworking_command(stem, sender, reply_to, msg)
    # Does person exist? If not create them
    person = Person.find(:first, :conditions => { :name => sender[:nick] })
    unless person
      stem.message 'You were never assigned to this ticket?', reply_to
      return 
    end
    
    # # Does the ticket exist? If not, create it
    ticket = Ticket.find(:first, :conditions => {:number => msg.to_i})
    unless ticket
      ticket = Ticket.create(:number => msg.to_i)
    end
        
    # #does the user belong to the ticket? If so, remove them
    pt = PeopleTicket.find(:first, :conditions => {:ticket_id => ticket.id, :person_id => person.id})
    unless pt.nil?
      pt.destroy
      stem.message "#{sender[:nick]} has stopped working on https://rails.lighthouseapp.com/projects/" + Lighthouse_Project.to_s + "/tickets/" + msg.to_s, reply_to
    else
      stem.message 'You were never assigned to this ticket?', reply_to
    end

    return
  end
  
  alias_method :stop_command, :stopworking_command
  
  def get_ticket_command(stem, sender, reply_to, msg)
    t = Ticket.from_lighthouseapp msg
    stem.message t['tag']
    
    return
  end
  
  def gimme_command(stem, sender, reply_to, msg)
    tickets = Lighthouse::Ticket.find(:all, :params => { :q => %{tagged:"bugmash"}, :project_id => 8994 } )
    free = tickets.select do |ticket|
      record = Ticket.find_by_number(ticket.id)
      if record
        !record.closed && record.people.empty?
      else
        !ticket.closed
      end
    end
    if free = free.rand
      stem.message "Ticket ##{free.id} - \"#{free.title}\" is available for you! https://rails.lighthouseapp.com/projects/" + Lighthouse_Project.to_s + '/tickets/' + free.id.to_s, reply_to
    else
      stem.message "There are no more tickets for you to have!", reply_to
    end
    
    return
  end
end
