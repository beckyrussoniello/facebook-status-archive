class AddMessageToStatus < ActiveRecord::Migration
  def change
		add_column :statuses, :message, :string
  end
end
