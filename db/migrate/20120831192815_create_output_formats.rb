class CreateOutputFormats < ActiveRecord::Migration
  def change
    create_table :output_formats do |t|
      t.string :name

      t.timestamps
    end
  end
end
