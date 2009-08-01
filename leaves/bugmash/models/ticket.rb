class Ticket < ActiveRecord::Base
  has_many :people_tickets
  has_many :people, :through => :people_tickets
end