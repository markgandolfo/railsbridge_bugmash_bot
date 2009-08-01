# Controller for the bugmash leaf.
require 'lighthouse_api'

class Controller < Autumn::Leaf
  
  # Typing "!about" displays some basic information about this leaf.
  
  def about_command(stem, sender, reply_to, msg)
    stem.message "hello"
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
    stem.message msg
    
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

  end
  
end
