class PagesController < ApplicationController
  def login; end
  def signup; end
  def goodbye
    @name = flash[:goodbye_name] || "friend"
  end
  def about; end
end
