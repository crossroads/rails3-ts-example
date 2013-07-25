class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.boolean :delta, :default => false
      t.timestamps
    end
  end
end
