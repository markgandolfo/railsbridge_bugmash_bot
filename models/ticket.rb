class Ticket < ActiveRecord::Base
  has_many :people_tickets
  has_many :people, :through => :people_tickets
  
  named_scope :number, lambda { |ticket_number| { :conditions => ['number > ?', ticket_number] }}
  
  def self.create_ticket(lighthouse_ticket)
    latest_version = lighthouse_ticket.versions.last.attributes
    Ticket.create!(latest_version.merge!(:cached_at => DateTime.now))
  end
  
  
  # Get the ticket from lighthouseapp
  def self.from_lighthouseapp ticket_id
    begin
      lighthouse_ticket = Lighthouse::Ticket.find(ticket_id, :params => { :project_id => Lighthouse_Project })
      latest_version = lighthouse_ticket.versions.last.attributes
      return latest_version
    rescue
      return
    end
    
    return
  end
  
  # is the ticket supposed to be bug mashable?
  def self.bug_mashable? ticket_id
    t = Ticket.from_lighthouseapp ticket_id
    unless t.nil?
      return t['tag'].to_s.include? 'bugmash' 
    end
  end
  
  
end