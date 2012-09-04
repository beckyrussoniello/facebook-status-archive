class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.integer :user_id
      t.string :output_format
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
