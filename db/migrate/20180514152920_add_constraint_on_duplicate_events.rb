class AddConstraintOnDuplicateEvents < ActiveRecord::Migration[5.1]
  def change
    add_index :events_gas, [:process_name, :date, :page_path], :unique => true
  end
end
