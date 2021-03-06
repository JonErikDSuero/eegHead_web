class Wave < ActiveRecord::Base

  attr_accessor :index

  def self.types
    {
      attention: 'Attention (Native)',
      quality: 'Quality',
      wave0: 'Delta',
      wave1: 'High Alpha',
      wave2: 'High Beta',
      wave3: 'Low Alpha',
      wave4: 'Low Beta',
      wave5: 'Low Gamma',
      wave6: 'Mid Gamma',
      wave7: 'Theta',
      meditation: 'Meditation (Native)',
      blink: 'Blink (Native)',
    }
  end

  def self.categorize(waves_values)
    waves = {
      quality: waves_values[0],
      wave0: waves_values[1],
      wave1: waves_values[2],
      wave2: waves_values[3],
      wave3: waves_values[4],
      wave4: waves_values[5],
      wave5: waves_values[6],
      wave6: waves_values[7],
      wave7: waves_values[8],
      attention: waves_values[9],
      meditation: waves_values[10],
      blink: waves_values[11],
    }
    return waves
  end

end

