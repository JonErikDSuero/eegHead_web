class AddTitleAndDurationToVideos < ActiveRecord::Migration
  def change
    # In seconds
    add_column :videos, :duration, :integer, :default => 0
    add_column :videos, :title, :string, :default => "Unknown"
  end
end
