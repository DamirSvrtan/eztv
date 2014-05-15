require 'httparty'
require 'pry'

module EZTV
  class ServerError < StandardError
  end

  class Base
    include HTTParty
    base_uri 'http://ezrss.it/search/index.php'

    RETRIES = 3

    def initialize(show_name)
      @options = { :query => {show_name: show_name, mode: "rss"} }
      @retries = RETRIES
    end

    def episodes
      return @episodes if @episodes

      result = self.class.get('',@options)
      if result.response.code_type == Net::HTTPServiceUnavailable
        if @retries > 0
          @retries -= 1
          self.episodes
        else
          raise ServerError
        end
      else
        @episodes = EpisodeFactory.create(result['rss']['channel']['item'])
      end
    end

    def episode(season, episode_number)
      episodes.find do |episode|
        episode.season == season and episode.episode_number == episode_number
      end
    end

    def season(season)
      episodes.find_all do |episode|
        episode.season == season
      end
    end
  end

  module EpisodeFactory
    def self.create(episodes_array)
      episodes = episodes_array.map do |episode_hash|
        Episode.new(episode_hash)
      end
    end
  end

  class Episode
    attr_accessor :show_name, :title, :season, :episode_number, :link, :magnet_link

    def initialize(episode_hash)
      desc = episode_hash["description"].split(';')
      @show_name = desc[0].match(/Show Name: (.+)/)[1]
      @title = desc[1].match(/Episode Title: (.+)/)[1]
      @season = desc[2].match(/Season: (.+)/)[1].to_i
      @episode_number = desc[3].match(/Episode: (.+)/)[1].to_i
      @link = episode_hash["enclosure"]["url"]
      @magnet_link = episode_hash["torrent"]["magnetURI"]
    end
  end
end

white_collar = EZTV::Base.new("white collar")

reze = white_collar.episode(1,3)
binding.pry

