class ServiceController < ApplicationController
  def index
    @services = Service.all.order("created_at DESC")
  end
end
