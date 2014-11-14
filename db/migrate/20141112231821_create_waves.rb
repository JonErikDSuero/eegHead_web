class CreateWaves < ActiveRecord::Migration
  def change
    create_table :waves do |t|
      t.datetime :timestamp
      t.integer :wave0, unsigned: true
      t.integer :wave1, unsigned: true
      t.integer :wave2, unsigned: true
      t.integer :wave3, unsigned: true
      t.integer :wave4, unsigned: true
      t.integer :wave5, unsigned: true
      t.integer :wave6, unsigned: true
      t.integer :wave7, unsigned: true
      t.integer :attention, unsigned: true
      t.integer :meditation, unsigned: true
      t.integer :blink, unsigned: true
      t.integer :quality, unsigned: true
      t.integer :video_id, unsigned: true
      t.integer :user_id, unsigned: true
      t.timestamps
    end

    create_table :results do |t|
      t.integer :attention, unsigned: true
      t.integer :sleep, unsigned: true
      t.integer :distraction, unsigned: true
      t.integer :video_id, unsigned: true
      t.integer :user_id, unsigned: true
      t.timestamps
    end
  end
end
