class PagesController < ApplicationController
  skip_before_action :require_authentication
  skip_before_action :require_complete_profile
  
  def tos
  end

  def privacy_policy
  end

  def support
  end
end
