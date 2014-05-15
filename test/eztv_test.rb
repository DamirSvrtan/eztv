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

  def test_first_episode
    first_episode = @white_collar.episodes.first
    assert_equal 1, first_episode.episode_number
    assert_equal 1, first_episode.season
    assert_equal "S01E01", first_episode.s01e01_format
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