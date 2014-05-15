require 'httparty'
require 'nokogiri'
require 'pry'

module EZTV
  class Series
    include HTTParty
    base_uri 'http://eztv.it'

    attr_reader :show_name

    def initialize(show_name)
      @show_name = show_name
      @options = { body: {'SearchString' => @show_name}}
    end

    def episodes
      return @episodes if @episodes
      
      result = self.class.post('/search/',@options)
      document = Nokogiri::HTML(result)

      episodes = document.css('html body div#header_holder table.forum_header_border tr.forum_header_border')

      episodes = episodes.reject do |episode| 
        episode.css('img').first.attributes['title'].value.match(/Show Description about #{show_name}/i).nil?
      end

      @episodes = EpisodeFactory.create(episodes)
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
    attr_accessor :season, :episode_number, :links, :magnet_link

    def initialize(episode_node)
      begin
        inner_text = episode_node.css('td.forum_thread_post a.epinfo').first.inner_text
        season_episode_match_data = inner_text.match(/S(\d{1,2})E(\d{1,2})/) || inner_text.match(/(\d{1,2})x(\d{1,2})/)

        @season = season_episode_match_data[1].to_i
        @episode_number = season_episode_match_data[2].to_i

        links_data = episode_node.css('td.forum_thread_post')[2]

        @magnet_link = links_data.css('a.magnet').first.attributes['href'].value

        @links = links_data.css('a')[2..-1].map do |a_element|
          a_element['href']
        end
      rescue => e
        binding.pry
      end
    end

  end
end

white_collar = EZTV::Series.new("white collar")
episodes = white_collar.episodes

episodes.each do |episode|
  puts episode.magnet_link
end