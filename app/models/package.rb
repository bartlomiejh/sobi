class Package < ActiveRecord::Base
  validates :message, :bikeId, presence: true
end
