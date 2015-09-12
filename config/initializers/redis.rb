require 'konf'

RedisConfig = Konf.new(File.expand_path('../../redis.yml', __FILE__), Rails.env)
