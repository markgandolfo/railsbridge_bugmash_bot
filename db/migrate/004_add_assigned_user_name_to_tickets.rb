class AddAssignedUserNameToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :assigned_user_name, :string
  end

  def self.down
  end
end


