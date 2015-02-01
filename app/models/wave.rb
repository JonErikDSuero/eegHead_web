class Wave < ActiveRecord::Base

  attr_accessor :index

  def self.types
    {
      quality: 'Quality',
      wave0: 'Delta',
      wave1: 'High Alpha',
      wave2: 'High Beta',
      wave3: 'Low Alpha',
      wave4: 'Low Beta',
      wave5: 'Low Gamma',
      wave6: 'Mid Gamma',
      wave7: 'Theta',
      attention: 'Attention (Native)',
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

  def self.process_attention_wave()
    json_headers = {"Content-Type" => "application/json", "Accept" => "application/json"}

    uri = URI.parse('http://eegheadflask.prombly.com/post_waves')


    params = [
      [
        0,
        {
          id: 2044,
          timestamp: "2015-01-08T15:16:36.000Z",
          wave0: 0,
          wave1: 0,
          wave2: 0,
          wave3: 0,
          wave4: 0,
          wave5: 0,
          wave6: 0,
          wave7: 0,
          attention: 0,
          meditation: 0,
          blink: 0,
          quality: 0,
          video_id: nil,
          user_id: nil,
          created_at: "2015-01-08T15:16:36.000Z",
          updated_at: "2015-01-08T15:16:36.000Z"
        }
      ],
      [
        1,
        {
          id: 2045,
          timestamp: "2015-01-08T15:16:37.000Z",
          wave0: 2,
          wave1: 2,
          wave2: 2,
          wave3: 2,
          wave4: 2,
          wave5: 2,
          wave6: 2,
          wave7: 2,
          attention: 2,
          meditation: 2,
          blink: 2,
          quality: 2,
          video_id: nil,
          user_id: nil,
          created_at: "2015-01-08T15:16:37.000Z",
          updated_at: "2015-01-08T15:16:37.000Z"
        }
      ],
      [
        2,
        {
          id: 2046,
          timestamp: "2015-01-08T15:16:39.000Z",
          wave0: 10,
          wave1: 10,
          wave2: 10,
          wave3: 10,
          wave4: 10,
          wave5: 10,
          wave6: 10,
          wave7: 10,
          attention: 10,
          meditation: 10,
          blink: 10,
          quality: 10,
          video_id: nil,
          user_id: nil,
          created_at: "2015-01-08T15:16:39.000Z",
          updated_at: "2015-01-08T15:16:39.000Z"
        }
      ]
    ]



    Net::HTTP.new(uri.host, uri.port).post(uri.path, params.to_json, json_headers)
  end

end

