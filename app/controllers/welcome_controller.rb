class WelcomeController < ApplicationController
  def index
    session[:scores] = []
    session[:number_of_games] = 0
  end
end
