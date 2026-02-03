class PagesController < ApplicationController
  def welcome; end
  def login; end
  def signup; end
  def goodbye
    @name = flash[:goodbye_name] || "friend"
  end
  def about; end
end
