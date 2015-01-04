class CreateVideoSessions < ActiveRecord::Migration
  def change
    create_table :video_sessions do |t|
      t.integer :user_id
      t.integer :video_id
      t.string :state
      t.integer :code, limit: 8
      t.timestamps
    end

    create_table :videos do |t|
      t.integer :owner_id
      t.string :code
      t.timestamps
    end
  end
end

