# frozen_string_literal: true

require './cards.rb'
require './hand.rb'

class BlackJack
  def initialize
    @player = Hand.new({})
    @dealer = Hand.new({})
    @cards = Cards.new
    @cards.take(Cards.new(joker: [0, 0]))
  end

  def run
    @cards.shuffle!

    player_drew_cards = @cards.draw(2)
    puts "You drew #{player_drew_cards.deck_to_a}\n"
    @player.add(player_drew_cards)

    dealer_drew_cards = @cards.draw(2)
    puts "Dealer drew #{dealer_drew_cards.deck_to_a[0]}\n"
    @dealer.add(dealer_drew_cards)

    until @player.over?
      puts "total: #{@player.total}"
      print 'stop? Y/n'
      break if readline == "Y\n"

      drawn_cards = @cards.draw(1)
      @player.add(drawn_cards)

      puts "You draw #{drawn_cards.deck_to_a}"
    end

    @dealer.add(@cards.draw(1)) while @dealer.total < 17 unless @player.over?

    puts <<~"EOS"
      Player: #{@player.total}
      Dealer: #{@dealer.total}
      Winner is #{judge}
    EOS
  end

  private

  def judge
    dealer_difference = (21 - @dealer.total).abs
    player_difference = (21 - @player.total).abs

    case true
    when @dealer.over? then 'player'
    when @player.over? then 'dealer'
    when dealer_difference == player_difference then 'none'
    when dealer_difference < player_difference then 'dealer'
    when dealer_difference > player_difference then 'player'
    end
  end
end
