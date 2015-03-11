class HomepageController < ApplicationController
  def index
  	@page_title = 'Welcome';
  end
  
  def about
  	@page_title = 'About Me';
  end

  def contact
  	@page_title = 'Contact Me';
  end
  
end
