class PeopleTicket < ActiveRecord::Base
  belongs_to :people
  belongs_to :ticket
end