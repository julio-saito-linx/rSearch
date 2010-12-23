require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

indice = -1
pesquisa = ""
if ARGV[0] =~ /\d+/
  indice = ARGV.shift.to_i
  pesquisa = ARGV.join('%20')
else
  pesquisa = ARGV.join('%20')
end

doc = Nokogiri::HTML(open('http://www.google.com/search?q=' + pesquisa))

# Do funky things with it using Nokogiri::XML::Node methods...

class GoogleLink
  attr_accessor :descricao, :link
end

####
# Search for nodes by css
titulos = doc.css('.l , .vst em')
links = doc.css('cite')

if indice != -1
  puts titulos[indice].content + "\t" + links[indice].content
  exit
end

listaDeLinks = []

conta = 0
for tit in titulos 
  googleLink = GoogleLink.new
  googleLink.descricao = tit.content
  googleLink.link = links[conta].content
  listaDeLinks.push googleLink
  conta = conta + 1
end

listaDeLinks.each{|googleLink| puts googleLink.descricao + "\t" + googleLink.link}

