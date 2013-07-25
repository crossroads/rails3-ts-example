class AddIndexes < ActiveRecord::Migration
  def up
    add_index :countries_documents, [:country_id, :document_id], :unique => true
    add_index :documents_subscribers, [:document_id, :subscriber_id], :unique => true
    add_index :documents_videos, [:document_id, :video_id], :unique => true
    add_index :documents_images, [:document_id, :image_id], :unique => true
    add_index :documents_tags, [:document_id, :tag_id], :unique => true
  end

  def down
  end
end
