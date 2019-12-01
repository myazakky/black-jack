# frozen_string_literal: true

require './cards.rb'

class Hand < Cards
  def total
    total_number = 0
    @cards_array.each do |card|
      _, number = card.to_a.flatten
      total_number += to_black_jack_number(number)
    end

    total_number
  end

  def over?
    total > 21
  end

  private

  def to_black_jack_number(number)
    case number
    when 11 then 10
    when 12 then 10
    when 13 then 10
    else number
    end
  end
end
