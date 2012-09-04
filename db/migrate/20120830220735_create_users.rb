class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :fb_id
      t.string :image_url
      t.string :oauth_token
      t.datetime :last_login_at
      t.string :oauth_secret

      t.timestamps
    end
  end
end
