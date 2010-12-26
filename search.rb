require 'rubygems'
require 'nokogiri'
require 'open-uri'

i = -1
pesquisa = ""
if ARGV[0] =~ /\d+/
  # has index
  i = ARGV.shift.to_i
  pesquisa = ARGV.join('%20')
else
  # all itens from first page
  pesquisa = ARGV.join('%20')
end

doc = Nokogiri::HTML(open('http://www.google.com/search?q=' + pesquisa))

# Search for nodes by css
links = doc.css('.l , .vst em')

# nothing founded
if links[0] == nil
  puts
  exit
end

# index specified
if i != -1
  puts links[i].content + "\t" + links[i][:href]
  exit
end

# first page
for tit in links
  puts tit.content + "\t" + tit[:href]
end