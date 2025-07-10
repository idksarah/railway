class AddDeviceToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      ## Rememberable
      t.datetime :remember_created_at

      ## Omniauthable
      t.string :provider
      t.string :uid
    end

    add_index :users, :email, unique: true
    add_index :users, %i[uid provider], unique: true
  end
end
