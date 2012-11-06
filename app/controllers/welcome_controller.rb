class WelcomeController < ApplicationController

  def index
    @main_categories = Category.main
    
  end

end
