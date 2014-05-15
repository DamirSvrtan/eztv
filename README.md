# EZTV

A Ruby scraper for the catastrophic EZTV API. It is not using the RSS feed since it doesn't work well, so it scrapes the search results.

## Installation

Add this line to your application's Gemfile:

    gem 'eztv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eztv

## Usage

```ruby
white_collar = EZTV::Series.new("white collar")

white_collar.episodes.each do |episode|
  puts episode.magnet_link
end

puts "Number of seasons: #{white_collar.seasons.count}"
puts "Number of episodes in season 1: #{white_collar.season(1).count}"

nonny = EZTV::Series.new("nonny")
begin
  nonny.episodes
rescue EZTV::SeriesNotFoundError => e
  puts e.message 
  => "Unable to find 'nonny' on https://eztv.it."
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/eztv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
