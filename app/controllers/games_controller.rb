class GamesController < ApplicationController
  def new
    # A page to display the game settings (random letters), with a form for the user to type a word. A button to submit this form.
    @letters = generate_letters(10)
    @start_time = Time.now

  end

  def score
    @end_time = Time.now
    @guess = params["guess"]
    @letters = params["letters"].split(' ')
    @start_time = Time.parse(params["start_time"])
    @result = run_game
  end

  private

  def generate_letters(number)
    letters = []
    number.times do
      letters << ('A'..'Z').to_a.sample
    end
    letters
  end

  def run_game
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)

    if word_in_grid? && english_word?
      { time: @end_time - @start_time, score: 100 * @guess.length / (@end_time - @start_time).to_f, message: "Well done!" }
    elsif !word_in_grid?
      { time: @end_time - @start_time, score: 0, message: "not in the grid" }
    elsif !english_word?
      { time: @end_time - @start_time, score: 0, message: "not an english word" }
    end
  end

  def word_in_grid?
    # binding.pry
    guess_arr = @guess.upcase.split('')
    grid_track = @letters.clone
    guess_arr.map do |item|
      if grid_track.index(item)
        grid_track.delete_at(grid_track.index(item))
      else
        return false
      end
    end
    true
  end

  def english_word?
    # binding.pry
    dictonary = URI.open("https://wagon-dictionary.herokuapp.com/#{@guess}").read
    JSON.parse(dictonary)['found']
  end



end

# Test
# controller = GamesController.new
