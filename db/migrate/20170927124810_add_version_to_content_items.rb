class AddVersionToContentItems < ActiveRecord::Migration[5.1]
  def change
    add_column :content_items, :user_facing_version, :integer
  end
end
