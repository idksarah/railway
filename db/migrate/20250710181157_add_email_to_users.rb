class AddEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :emails, :string
  end
end
