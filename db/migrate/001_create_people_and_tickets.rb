class CreatePeopleAndTickets < ActiveRecord::Migration
  def self.up
    create_table "people", :force => true do |t|
      t.string  "name"
      t.integer "chats_count", :default => 0
      t.text "notes"
      t.timestamps
    end

    create_table "tickets", :force => true do |t|
        t.integer 'assigned-user-id'
        t.integer 'attachments-count'
        t.text 'body'
        t.text 'body-html'
        t.datetime 'created-at'
        t.integer 'creator-id'
        t.integer 'milestone-id'
        t.integer 'number'
        t.string 'permalink'
        t.integer 'project_id'
        t.string 'state'
        t.string 'title'
        t.datetime 'updated-at'
        t.integer 'user_id'
        t.text 'tag'      
    end


  end

  def self.down
    drop_table "people"
    drop_table "tickets"
  end
end


