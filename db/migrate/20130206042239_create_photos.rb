class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :collection

      t.timestamps
    end
    add_index :photos, :collection_id
  end
end
