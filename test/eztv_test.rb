require "minitest/autorun"
require 'eztv'
class TestExistingSeries < Minitest::Test
  def setup
    @white_collar = EZTV::Series.new("white collar")
  end

  def test_series_name
    assert_equal "white collar", @white_collar.name
  end

  def test_episodes_count
    assert_equal 75, @white_collar.episodes.count
  end

  def test_seasons_count
    assert_equal 5, @white_collar.seasons.count
  end
end

class TestNonExistingSeries < Minitest::Test
  def setup
    @nonny = EZTV::Series.new("nonny")
  end

  def test_raises_if_not_found
    assert_raises EZTV::SeriesNotFoundError do
      @nonny.episodes
    end
  end
end