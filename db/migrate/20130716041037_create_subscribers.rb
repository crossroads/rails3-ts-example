class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
