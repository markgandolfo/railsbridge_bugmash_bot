class CreatePeopleAndTickets < ActiveRecord::Migration
  def self.up
    create_table "people", :force => true do |t|
      t.string  "name"
      t.timestamps
    end

    create_table "tickets", :force => true do |t|
        t.integer 'assigned_user_id'
        t.integer 'attachments_count'
        t.text 'body'
        t.text 'body_html'
        t.integer 'creator_id'
        t.integer 'milestone_id'
        t.integer 'number'
        t.string 'permalink'
        t.integer 'project_id'
        t.string 'state'
        t.string 'title'
        t.string 'creator_name'
        t.string 'milestone_title'
        t.string 'url'
        t.text 'diffable_attributes'
        t.boolean 'closed'
        t.string 'user_name'
        t.integer 'user_id'
        t.text 'tag'
        t.datetime 'cached_at'
        
        t.timestamps
    end
  end

  def self.down
    drop_table "people"
    drop_table "tickets"
  end
end


