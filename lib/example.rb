require_relative 'eztv/app'
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
end