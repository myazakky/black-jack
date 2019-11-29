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

cards = Cards.new
p cards.draw(3)
p cards.shuffle
