class PackagesController < ApplicationController
  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all.order('created_at DESC')
  end
end
