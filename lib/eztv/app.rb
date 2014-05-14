require 'httparty'
  options = {show_name: "trophy wife", mode: :rss}
  response = HTTParty.get('http://ezrss.it/search/index.php', query: options)
  puts response.body, response.code, response.message, response.headers.inspect