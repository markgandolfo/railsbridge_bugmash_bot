class CreateTags < ActiveRecord::Migration
  def self.up
    create_table "tags", :force => true do |t|
      t.string  "name"
    end

    create_table "tags_tickets", :force => true do |t|
      t.integer :tag_id
      t.integer :ticket_id
    end
  end

  def self.down
  end
end


