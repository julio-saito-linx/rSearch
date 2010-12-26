require 'rubygems'
require 'nokogiri'
require 'open-uri'

i = -1
pesquisa = ""
regexFinder = nil

if ARGV[0] =~ /\d+/
  # has index
  i = ARGV.shift.to_i
  pesquisa = ARGV.join('%20')
elsif ARGV[0] =~ /^\/(.*?)\/(\w*)$/
  # has regular expression finder
  # searchs for group 1 in regex
  reg = ARGV.shift
  regexFinder = Regexp.new(/^\/(.*?)\/(\w*)$/.match(reg)[1])
  pesquisa = ARGV.join('%20')
else
  # all itens from first page
  pesquisa = ARGV.join('%20')
end

begin
  doc = Nokogiri::HTML(open('http://www.google.com/search?q=' + pesquisa))

rescue => error
  puts ":: error :: " + error
  exit
end

#regex search
if regexFinder != nil
  doc.css(".s").each do |item|
    if(item.text =~ regexFinder)
      puts regexFinder.match(item.text)[0] + "\t" + pesquisa
      exit
    end
  end
  puts 
  exit
end

puts 'chegou aki'

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