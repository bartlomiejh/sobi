class Package < ActiveRecord::Base
  validates :message, :bike_id, presence: true
end
