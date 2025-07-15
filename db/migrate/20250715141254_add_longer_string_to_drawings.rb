class AddLongerStringToDrawings < ActiveRecord::Migration[8.0]
  def change
    change_column :drawings, :image_url, :text
  end
end
