require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'

def SaveImage full_url, fileName
  http_start = full_url.match(/http:\/\/(.*?)\//)[1]
  http_url_continues = full_url.match(/http:\/\/.*?(\/.*)/)[1]

  Net::HTTP.start(http_start) { |http|
    resp = http.get(http_url_continues)
    open(fileName, "wb") { |file|
      file.write(resp.body)
     }
  }
  puts "#{fileName} was saved on disk"
end

# Get a Nokogiri::HTML:Document for the page we’re interested in...

if ARGV.length != 2
  puts "usage: ruby Imdb_get_Info.rb \"c:\\movies\\my film.avi\" http://www.imdb.com/title/tt0909090/"
  exit
end

caminhoPath = ARGV[0]
caminhoPath_match = caminhoPath.match(/^(.*\\)(.*?)\.(\w+)$/)
caminhoPath_directory = caminhoPath_match[1]
caminhoPath_filename = caminhoPath_match[2]
caminhoPath_filename_extension = caminhoPath_match[3]

linkImdb = ARGV[1]


doc = Nokogiri::HTML(open(linkImdb))

# Search for nodes by css
header = doc.css('.header').text
header_title = header.match(/^([\w ]+)$/)[1]
header_year = header.match(/\d{4}/)[0]
rating = doc.css('.rating-rating').text
overview = doc.css('#overview-top p').text.match(/^[\s\n\r]+(.*)$/m)[1]

# save imdb-info.txt file
open(caminhoPath_directory + caminhoPath_filename + "_imdb.txt", "w") { |file|
  file.write(header_title + "("+ header_year +") - "+ rating + "\n")
  file.write(overview)
  file.close
}

imagemLink = doc.css('#img_primary img').first[:src]

# get big image imdb page
start_url = "http://www.imdb.com"
big_image_url = start_url + doc.css('td#img_primary a').first[:href]
doc = Nokogiri::HTML(open(big_image_url))
#first big image url for the image
imagemBigLink = doc.css('#primary-img').first[:src]

#save images on disk
SaveImage imagemLink, caminhoPath_directory + caminhoPath_filename + "_imdb_img.jpg"
SaveImage imagemBigLink, caminhoPath_directory + caminhoPath_filename + "_imdb_img_BIG.jpg"

