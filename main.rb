class Cards
  attr_reader :cards

  def initialize
    @cards = (1..13).to_a * 4
  end

  def draw
    drawed_number = @cards.sample
    @cards.slice!(@cards.index(drawed_number))
    drawed_number
  end

end

cards = Cards.new