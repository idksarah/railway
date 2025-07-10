class RemoveImageIdAddSlackIdToDrawings < ActiveRecord::Migration[8.0]
  def change
    remove_column :drawings, :image_id
    add_column :drawings, :slack_id, :string
  end
end
