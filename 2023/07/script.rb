# frozen_string_literal: true

data = File.read("input.txt")

def part1(data)
  hands = data.split("\n").map { |line| line.split(" ") }
  hands = hands.map do |hand, bid|
    Hand.new(hand, bid)
  end

  hand_ordering = hands.sort.reverse
  puts hand_ordering.map(&:hand)
  result = hands.sort.reverse.each_with_index.map do |hand, index|
    hand.bid * (index + 1)
  end.to_a
  puts result.sum
end

class Hand
  attr_reader :hand, :bid

  def initialize(hand, bid)
    @hand = hand
    @bid = Integer(bid)
  end

  def <=>(other)
    self_strength = hand_strength
    other_strength = other.hand_strength

    return self_strength <=> other_strength unless self_strength == other_strength

    last = 0
    5.times do |i|
      last = i
      if card_strength(hand[i]) != card_strength(other.hand[i])
        break
      end
    end

    card_strength(hand[last]) <=> card_strength(other.hand[last])
  end

  def hand_type
    counts = hand.split("").each_with_object({}) do |card, hash|
      hash[card] = hash.fetch(card, 0) + 1
    end
    joker_count = counts.delete("J") unless counts["J"] == 5

    card_counts = counts.values.sort.reverse!
    card_counts[0] += joker_count if joker_count
    case card_counts
    when [5]
      :five_of_a_kind
    when [4, 1]
      :four_of_a_kind
    when [3, 2]
      :full_house
    when [3, 1, 1]
      :three_of_a_kind
    when [2, 2, 1]
      :two_pair
    when [2, 1, 1, 1]
      :one_pair
    when [1, 1, 1, 1, 1]
      :high_card
    else
      binding.irb
      raise "uh oh unknown hand"
    end
  end

  def hand_strength
    res = [
      :five_of_a_kind,
      :four_of_a_kind,
      :full_house,
      :three_of_a_kind,
      :two_pair,
      :one_pair,
      :high_card,
    ].find_index(hand_type)

    binding.irb if res.nil?

    res
  end

  def card_strength(card)
    [
      "A",
      "K",
      "Q",
      "T",
      "9",
      "8",
      "7",
      "6",
      "5",
      "4",
      "3",
      "2",
      "J",
    ].find_index(card)
  end
end

def part2(data)
end

part1(data)

# puts Hand.new("KTJJ1", "220").hand_type
