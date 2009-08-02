# Controller for the bugmash leaf.
require 'lighthouse'
Lighthouse.account = 'rails'
Lighthouse_Project = 8994

class Controller < Autumn::Leaf
    
  # Typing "!about" displays some basic information about this leaf.
  def about_command(stem, sender, reply_to, msg)
    
    stem.message "You can use me to keep track of lighthouse tickets, this will not update lighthouse, but only use it as a reference"
    stem.message ""
    stem.message "!status 1 - who is working on the ticket"
    stem.message "!working 1 - will assign you to the ticket"
    stem.message "!stopworking 1 - will unassign you from the ticket"
    return
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
    
    if Ticket.bug_mashable? msg.to_i
      stem.message 'This ticket is not bug mashable, please try another'
      return false
    end

    # If we're here, it means the ticket is a valid bug masher ticket. 
    ticket = Ticket.find(:first, :conditions => { :number => msg.to_i })
    if ticket
      person_tickets = PeopleTicket.find(:all, :conditions => {:ticket_id => ticket.id })
    
      unless person_tickets.empty?
        returned_string = ''
        person_tickets.each { |pt| returned_string += pt.person.name + ','}
        stem.message returned_string + ' is working on ticket https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s
      else
        stem.message 'nobody is working on ticket https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s
      end
    
    else
      ticket = Ticket.create(:number => msg.to_i)
      stem.message 'nobody is working on ticket https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s
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
      person = Person.find(:first, :conditions => { :name => sender[:nick] })
      unless person
        person = Person.create(:name => sender[:nick])
      end
    
      # Does the ticket exist? If not, create it
      ticket = Ticket.find(:first, :conditions => {:number => msg.to_i})
      unless ticket
        ticket = Ticket.create(:number => msg.to_i)
      end
    
      # Add the person/ticket relationship.
      pt = PeopleTicket.find(:all, :conditions => {:ticket_id => ticket.id, :person_id => person.id})

      if pt.nil?
        stem.message sender[:nick] + ' is already working on ' + 'https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s
      else
        pt = PeopleTicket.create(:ticket_id => ticket.id, :person_id => person.id, :state => 'working')
        stem.message sender[:nick] + ' is now working on ' + 'https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s
      end
    else
      
    end
    return
  end
  
  
  # Stop working on a ticket
  def stopworking_command(stem, sender, reply_to, msg)
    # Does person exist? If not create them
    person = Person.find(:first, :conditions => { :name => sender[:nick] })
    unless person
      stem.message 'You were never assigned to this ticket?'
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
      stem.message 'You have been removed from https://rails.lighthouseapp.com/projects/' + Lighthouse_Project.to_s + '/tickets/' + msg.to_s
    else
      stem.message 'You were never assigned to this ticket?'
    end

    return
  end
  
  def get_ticket_command(stem, sender, reply_to, msg)
    t = Ticket.from_lighthouseapp msg
    stem.message t['tag']
    
    return
  end
end
