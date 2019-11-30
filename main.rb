# frozen_string_literal: true

class Card
  def initialize(deck = nil, cards_array = nil)
    @deck = deck.nil? ? new_deck : deck
    @cards_array = cards_array.nil? ? deck_to_a : cards_array
  end

  def shuffle!
    Card.new(@deck, @cards_array.shuffle!)
  end

  def draw(any_number)
    drawed_card = Card.new({}, [])
    @cards_array[0, any_number].each do |card|
      drawed_card.add(card)

      symbol, number = card.to_a.flatten!
      @deck[symbol].delete(number)
    end
    @cards_array.slice!(0, any_number)

    drawed_card
  end

  def add(card)
    @cards_array.append(card)

    symbol, number = card.to_a.flatten!
    if @deck[symbol].nil?
      @deck[symbol] = [number]
    else
      @deck[symbol].append(number)
    end

    Card.new(@deck, @cards_array)
  end

  def deck_to_a
    cards_array = []
    @deck.each do |symbol, number_array|
      number_array.each { |number| cards_array.append(symbol => number) }
    end
    cards_array
  end

  private

  def new_deck
    {
      spade: (1..13).to_a,
      diamond: (1..13).to_a,
      heart: (1..13).to_a,
      club: (1..13).to_a,
      joker: [0, 0]
    }
  end
end
