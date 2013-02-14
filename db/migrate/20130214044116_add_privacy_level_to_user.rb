class AddPrivacyLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :privacy_level, :string, default: "public"
  end
end
