json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :professor
  json.url user_url(user, format: :json)
end
