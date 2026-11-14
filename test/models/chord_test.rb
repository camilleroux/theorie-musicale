require 'test_helper'

class ChordTest < ActiveSupport::TestCase
  def tensions(slug, key = 'C')
    tensions = Chord.friendly.find(slug).in_key_of(Key[key]).tensions
    tensions && [tensions.available.map(&:first), tensions.avoid.map(&:first)]
  end

  test 'should find tensions and avoid notes from the main related mode' do
    assert_equal [%w[9 13], %w[11]], tensions('majeur-7')
    assert_equal [%w[9 11 13], []], tensions('mineur-7')
    assert_equal [%w[11 ♭13], %w[♭9]], tensions('demi-diminue')
  end

  test 'should allow the ♭9 and ♭13 of an altered dominant' do
    assert_equal [%w[♭9 ♯11 ♭13], []], tensions('7-diese9')
  end

  test 'should not give tensions for triads' do
    assert_nil tensions('majeur')
  end
end
