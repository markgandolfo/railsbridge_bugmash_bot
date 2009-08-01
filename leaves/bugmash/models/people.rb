class People < ActiveRecord::Base
  has_many :people_tickets
  has_many :tickets, :through => :people_tickets
end