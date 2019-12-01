# frozen_string_literal: true

class Cards
  attr_reader :deck

  def initialize(deck = nil, cards_array = nil)
    @deck = deck.nil? ? new_deck : deck
    @cards_array = cards_array.nil? ? deck_to_a : cards_array
  end

  def shuffle!
    Cards.new(@deck, @cards_array.shuffle!)
  end

  def draw(any_number)
    drawn_cards = Cards.new({})
    @cards_array[0, any_number].each do |card|
      symbol, number = card.to_a.flatten
      drawn_cards.add(Cards.new(symbol => [number]))

      @deck[symbol].delete(number)
    end
    @cards_array.slice!(0, any_number)

    drawn_cards
  end

  def take(cards)
    cards.deck_to_a.each do |card|
      symbol, number = card.to_a.flatten
      @deck[symbol].delete(number)
      @cards_array.delete(card)
    end

    Cards.new(@deck, @cards_array)
  end

  def add(cards)
    cards.deck_to_a.each do |card|
      symbol, number = card.to_a.flatten
      @deck[symbol] = @deck[symbol].nil? ? [number] : @deck[symbol].append(number)
      @cards_array.append(card)
    end

    Cards.new(@deck, @cards_array)
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
