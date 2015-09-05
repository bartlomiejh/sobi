json.array!(@packages) do |package|
  json.extract! package, :id, :created_at, :bike_id, :message
  json.url package_url(package, format: :json)
end
