require 'open-uri'
require 'json'

class GamesController < ApplicationController
 VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "" ).upcase
    @english_word = english_word?(@word)
    @included = included?(@word, @letters)
    @score = 0
    if @included && @english_word
    @score += @word.length
    end
    session[:score] += @score


  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_infos = JSON.parse(open(url).read)
    return word_infos["found"]
  end
end
