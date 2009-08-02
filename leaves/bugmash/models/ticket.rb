class Ticket < ActiveRecord::Base
  has_many :people_tickets
  has_many :people, :through => :people_tickets
  
  named_scope :number, lambda { |ticket_number| { :conditions => ['number > ?', ticket_number] }}
  
  def self.create_ticket(lighthouse_ticket)
    latest_version = lighthouse_ticket.versions.last.attributes
    Ticket.new(
      :assigned_user_id => latest_version['assigned_user_id'],
      :attachments_count => latest_version['attachments_count'],
      :body => latest_version['body'],
      :body_html => latest_version['body_html'],
      :creator_id => latest_version['creator_id'],
      :milestone_id => latest_version['milestone_id'],
      :number => latest_version['number'],
      :permalink => latest_version['permalink'],
      :project_id => latest_version['project_id'],
      :state => latest_version['state'],
      :title => latest_version['title'],
      :user_id => latest_version['user_id'],
      :tag => latest_version['tag'],
      :created_at => latest_version['created_at'],
      :cached_at => DateTime.now
    ).save
    
    latest_version
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
      t['tag'].include? 'bugmash' 
    end
  end
  
  
end