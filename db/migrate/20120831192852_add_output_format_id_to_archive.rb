class AddOutputFormatIdToArchive < ActiveRecord::Migration
  def change
		remove_column :archives, :output_format
		add_column :archives, :output_format_id, :integer
  end
end
