class CreateMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :metrics do |t|
      t.string :content_id
      t.string :code
      t.integer :value
      t.date :day

      t.timestamps
    end
  end
end
