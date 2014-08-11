require 'open-uri'
require 'json'


class GameController < ApplicationController
  def new_game
    @array = ("A".."Z").to_a
    @generated_grid = []
    for i in (1..15)
      @generated_grid << @array[rand(26)]
    end
    session[:generated_grid] = @generated_grid
    session[:start_time] = Time.now
  end

  def score
    attempt = params[:attempt]
    grid = session[:generated_grid]
    start_time = session[:start_time].to_time
    end_time = Time.now
    @result = run_game(attempt, grid, start_time, end_time)
    session[:number_of_games] += 1
  end

  private
    def run_game(attempt, grid, start_time, end_time)
    #TODO: runs the game and return detailed hash of result
    result = Result.new
    result.time = end_time - start_time
    if check_if_included?(attempt, grid)
      if translation(attempt).nil?
        result.translation = "No valid translation"
        result.score = 0
        result.message = "Sorry! It was not an english word"
      else
        result.translation = translation(attempt)
        result.score = "#{attempt.split(//).count + 1.to_f / (end_time - start_time)}"
        result.message = "Well done!"
      end
    else
      result.translation = translation(attempt)
      result.score = 0
      result.message = "Sorry! The letters were not all in the grid"
    end
    return result
  end

    def check_if_included?(attempt, grid)
      letters = attempt.upcase.split("")
      letters.all? { |letter| letters.count(letter) <= grid.count(letter) }
    end

    def translation(attempt)
      translated_word = ""
      api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
      api_return = {}
      open(api_url) do |stream|
        api_return = JSON.parse(stream.read)
      end
      if api_return.has_key?("Error")
        translated_word = nil
      else
        translated_word = api_return["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
      end
      return translated_word
    end

end
