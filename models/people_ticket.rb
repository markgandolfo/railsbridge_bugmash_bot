class PeopleTicket < ActiveRecord::Base
  belongs_to :person
  belongs_to :ticket
end