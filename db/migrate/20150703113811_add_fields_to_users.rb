class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :twitter_token, :string
    add_column :users, :twitter_secret, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
