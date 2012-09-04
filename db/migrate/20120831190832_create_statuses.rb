class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :user_id
      t.integer :archive_id
      t.datetime :timestamp

      t.timestamps
    end
  end
end
