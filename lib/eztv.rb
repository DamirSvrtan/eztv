require 'httparty'
require 'nokogiri'
require 'pry'

module EZTV
  SE_FORMAT = /S(\d{1,2})E(\d{1,2})/
  X_FORMAT = /(\d{1,2})x(\d{1,2})/

  class SeriesNotFoundError < StandardError
    def initialize(series)
      msg = "Unable to find '#{series.name}' on https://eztv.it."
      super(msg)
    end
  end

  class Series
    include HTTParty
    attr_reader :name
    base_uri 'http://eztv.it'

    def initialize(name)
      @name = name
      @options = { body: {'SearchString' => @name}}
    end

    def episodes
      return @episodes if @episodes
      
      result = self.class.post('/search/',@options)
      document = Nokogiri::HTML(result)
      episodes = document.css('html body div#header_holder table.forum_header_border tr.forum_header_border')

      raise SeriesNotFoundError.new(self) if episodes.empty?

      episodes = episodes.reject do |episode| 
        episode.css('img').first.attributes['title'].value.match(/Show Description about #{name}/i).nil?
      end

      @episodes = EpisodeFactory.create(episodes)
    end

    def episode(season, episode_number)
      episodes.find do |episode|
        episode.season == season and episode.episode_number == episode_number
      end
    end

    def get(s01e01_format)
      season_episode_match_data = s01e01_format.match(EZTV::SE_FORMAT)
      season  = season_episode_match_data[1].to_i
      episode_number = season_episode_match_data[2].to_i
      return episode(season, episode_number)
    end

    def season(season)
      episodes.find_all {|episode| episode.season == season }
    end

    def seasons
      episodes.group_by {|episode| episode.season }.to_hash.values
    end
  end

  module EpisodeFactory
    def self.create(episodes_array)
      episodes = episodes_array.reverse.map do |episode_hash|
        Episode.new(episode_hash)
      end.uniq
    end
  end

  class Episode
    attr_accessor :season, :episode_number, :links, :magnet_link

    def initialize(episode_node)
      inner_text = episode_node.css('td.forum_thread_post a.epinfo').first.inner_text
      season_episode_match_data = inner_text.match(EZTV::SE_FORMAT) || inner_text.match(EZTV::X_FORMAT)

      @season = season_episode_match_data[1].to_i
      @episode_number = season_episode_match_data[2].to_i

      links_data = episode_node.css('td.forum_thread_post')[2]

      @magnet_link = links_data.css('a.magnet').first.attributes['href'].value

      @links = links_data.css('a')[2..-1].map do |a_element|
        a_element['href']
      end
    end

    def s01e01_format
      @s01e01_format ||= "S#{season.to_s.rjust(2,'0')}E#{episode_number.to_s.rjust(2,'0')}"
    end

    def eql?(other)
      other.hash == self.hash
    end

    def hash
      [episode_number, season].hash
    end
  end
end