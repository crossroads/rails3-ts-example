class JoinTables < ActiveRecord::Migration
  def up
    create_table :countries_documents, :id => false do |t|
      t.references :country, :document
    end
    create_table :documents_subscribers, :id => false do |t|
      t.references :document, :subscriber
    end
    create_table :documents_videos, :id => false do |t|
      t.references :document, :video
    end
    create_table :documents_images, :id => false do |t|
      t.references :document, :image
    end
    create_table :documents_tags, :id => false do |t|
      t.references :document, :tag
    end
  end

  def down
  end
end
