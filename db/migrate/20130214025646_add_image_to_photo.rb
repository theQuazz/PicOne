class AddImageToPhoto < ActiveRecord::Migration
  def self.up
    add_attachment :photos, :image
    remove_column :photos, :path
  end
  def self.down
    remove_attachment :photos, :image
    add_column :photos, :path, :string
  end
end
