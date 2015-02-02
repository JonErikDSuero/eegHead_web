class CreateWaveLogs < ActiveRecord::Migration
  def change
    create_table :wave_logs do |t|
      t.datetime :timestamp
      t.string :body
    end
  end
end
