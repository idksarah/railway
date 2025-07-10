class AddImageDataToDrawings < ActiveRecord::Migration[8.0]
  def change
    add_column :drawings, :image_data, :string
  end
end
