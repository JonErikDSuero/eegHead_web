class Wave < ActiveRecord::Base

  def self.categorize(waves_values)
    waves = {
      wave0: waves_values[0],
      wave1: waves_values[1],
      wave2: waves_values[2],
      wave3: waves_values[3],
      wave4: waves_values[4],
      wave5: waves_values[5],
      wave6: waves_values[6],
      wave7: waves_values[7],
      attention: waves_values[8],
      meditation: waves_values[9],
      blink: waves_values[10],
      quality: waves_values[11]
    }
    return waves
  end

end
