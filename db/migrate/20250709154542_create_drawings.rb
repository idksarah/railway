class CreateDrawings < ActiveRecord::Migration[8.0]
  def change
    create_table :drawings do |t|
      t.string :artist

      t.timestamps
    end
  end
end
