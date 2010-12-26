require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

if ARGV.length == 0
  puts
  exit
end

doc = Nokogiri::HTML(open(ARGV.join('%20')))

# Search for nodes by css
release = doc.css('h2 a').text
imdbLink = doc.css('p:nth-child(2) a').first[:href]

puts release + "\t" + imdbLink