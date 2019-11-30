class Cards
  def initialize(arg_deck = nil, arg_cards = nil)
    @deck = arg_deck.nil? ? deck : arg_deck
    @cards = arg_cards.nil? ? to_a : arg_cards
  end

  def shuffle
    @cards.shuffle!
    Cards.new(@deck, @cards)
  end

  def draw(any_number)
    @cards[0, any_number].each do |card|
      symbol, value = card.to_a.flatten!
      @deck[symbol].delete(value)
    end
    @cards.slice!(0, any_number)
    Cards.new(@deck, @cards)
  end

  def take(symbol, number)
    @deck[symbol].delete(number)
    @cards.delete(symbol => number)
    Cards.new(@deck, @cards)
  end

  def add(symbol, number)
    @deck[symbol].append(number)
    @cards.append(symbol => number)
  end

  def to_a
    cards = []
    @deck.each do |symbol, numbers|
      numbers.each { |num| cards.append(symbol => num) }
    end
    cards
  end

  private

  def deck
    {
      spade: (1..13).to_a,
      club: (1..13).to_a,
      diamond: (1..13).to_a,
      heart: (1..13).to_a,
      joker: [0, 0]
    }
  end
end

class Player
  def initialize
    @hand = Cards.new
  end

  def add(symbol, number)
    @hand.add(symbol, number)
  end
end
