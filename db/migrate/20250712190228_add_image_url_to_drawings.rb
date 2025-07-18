class AddImageUrlToDrawings < ActiveRecord::Migration[8.0]
  def change
    add_column :drawings, :image_url, :string
  end
end
