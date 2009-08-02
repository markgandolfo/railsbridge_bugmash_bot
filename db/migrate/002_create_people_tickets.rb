class CreatePeopleTickets < ActiveRecord::Migration
  def self.up
    create_table "people_tickets", :force => true do |t|
      t.integer "person_id"
      t.integer "ticket_id"
      t.string "state"
      t.timestamps
    end
  end

  def self.down
    drop_table "people_tickets"
  end
end