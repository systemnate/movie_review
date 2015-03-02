class PagesControllerController < ApplicationController
  def about
  end
  
  def google
    render :layout => false
  end

  def sitemap
    render :layout => false
  end
end