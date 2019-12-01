# frozen_string_literal: true

class Cards
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

class Hand < Cards
  def total
    total_number = 0
    @cards_array.each do |card|
      _, number = card.to_a.flatten
      total_number += to_black_jack_number(number)
    end

    total_number
  end

  def to_black_jack_number(number)
    case number
    when 11 then 10
    when 12 then 10
    when 13 then 10
    else number
    end
  end
end

class BlackJack
  def initialize
    @player = Hand.new({})
    @dealer = Hand.new({})
    @cards = Cards.new
  end

  def run
    @cards.shuffle!

    player_drew_cards = @cards.draw(2)
    puts "You drew #{player_drew_cards.deck_to_a}\n"
    @player.add(player_drew_cards)

    dealer_drew_cards = @cards.draw(2)
    puts "Dealer drew #{dealer_drew_cards.deck_to_a[0]}\n"
    @dealer.add(dealer_drew_cards)

    while @player.total <= 21
      drawn_cards = @cards.draw(1)
      @player.add(drawn_cards)

      puts <<~"EOS"
        You draw #{drawn_cards.deck_to_a}
        total: #{@player.total}
      EOS
      print 'stop? Y/n'
      break if readline == "Y\n"
    end

    @dealer.add(@cards.draw(1)) while @dealer.total < 17

    puts <<~"EOS"
      Player: #{@player.total}
      Dealer: #{@dealer.total}
      Winner is #{judge}
    EOS
  end

  private

  def judge
    if 21 - @dealer.total < 21 - @player.total || @player.total > 21
      'dealer'
    else
      'player'
    end
  end
end

game = BlackJack.new
game.run
