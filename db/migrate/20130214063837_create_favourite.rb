class CreateFavourite < ActiveRecord::Migration
  def up
    create_table :favourites do |t|
      t.references :user, :null => false
      t.references :photo, :null => false
      t.references :collection, :null => false
      t.timestamps
    end

    add_index :favourites, :user_id
    add_index :favourites, :photo_id
    add_index :favourites, :collection_id
  end

  def down
    drop_table :favourites
  end
end
