require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

doc = Nokogiri::HTML(open('http://www.google.com/search?q=saitodisse'))

# Do funky things with it using Nokogiri::XML::Node methods...

class GoogleLink
  attr_accessor :descricao, :link
end

####
# Search for nodes by css
titulos = doc.css('.l , .vst em')
links = doc.css('cite')

listaDeLinks = []

conta = 0
for tit in titulos 
  googleLink = GoogleLink.new
  googleLink.descricao = tit.content
  googleLink.link = links[conta].content
  listaDeLinks.push googleLink
  conta = conta + 1
end

listaDeLinks.each{|googleLink| puts googleLink.descricao + ' ( ' + googleLink.link + " );"}

