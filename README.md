# EZTV
[![Build Status](https://travis-ci.org/DamirSvrtan/eztv.svg?branch=master)](https://travis-ci.org/DamirSvrtan/eztv)
[![Gem Version](https://badge.fury.io/rb/eztv.svg)](http://badge.fury.io/rb/eztv)
[![Dependencies Status](https://gemnasium.com/DamirSvrtan/eztv.png)](https://gemnasium.com/DamirSvrtan/eztv)
[![Code Climate](https://codeclimate.com/github/DamirSvrtan/eztv.png)](https://codeclimate.com/github/DamirSvrtan/eztv)

A Ruby scraper as a substitution for the catastrophic [EZTV](http://eztv.it/) API. It is not using the RSS feed since it doesn't work well, so it scrapes the search results.

## Installation

Add this line to your application's Gemfile:

    gem 'eztv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eztv

## Usage

Fetch a series and get all the magnet links:
```ruby
require 'eztv'

white_collar = EZTV::Series.new("white collar")

white_collar.episodes.each do |episode|
  puts episode.magnet_link
end
```

Get all regular torrent download links from S01E01:

```ruby
white_collar.episode(1,1).links
# ["//torrent.zoink.it/White.Collar.S01E01.Pilot.HDTV.XviD-FQM.[eztv].torrent",
# "http://www.mininova.org/tor/3077342",
# "http://www.bt-chat.com/download.php?info_hash=e0e74306adca549be19b147b5ee14bde1b99bb1d"]
```

Get number of seasons or number of episodes per season:
```ruby
puts "Number of seasons: #{white_collar.seasons.count}"
# Number of seasons: 5
puts "Number of episodes in season 1: #{white_collar.season(1).count}"
# Number of episodes in season 1: 13
```

Get the last episode of the latest season in S01E01 format:
```ruby
white_collar.episodes.last.s01e01_format
# S05E13
```

Fetch an episode in S01E01 format:
```ruby
white_collar.get('S03E05')
# EZTV::Episode.new
```
There will be an error raised if you browsed for a non existing series:
```ruby
nonny = EZTV::Series.new("nonny")
begin
  nonny.episodes
rescue EZTV::SeriesNotFoundError => e
  puts e.message 
  # "Unable to find 'nonny' on https://eztv.it."
end
```

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
