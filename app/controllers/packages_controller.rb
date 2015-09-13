class PackagesController < ApplicationController
  # GET /packages
  # GET /packages.json
  def index
    # @todo bhopek: move job execution to scheduler/background
    GetPackagesJob.perform_now
    @packages = Package.all.order('created_at DESC')
  end
end
