require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'fastercsv'

class LinkChecker
 
  attr_accessor :urls, :max_urls
  
  def initialize(url)
    self.urls = [url]
    self.max_urls = 10
  end
 
  def stats
    self.urls.each do |url|
      start = Time.now
      response = open(url)
      puts "#{url} : #{Time.now - start}s | #{response.status[0]}"
    end
  end

  def grab
    self.urls.each do |url|
        doc = Nokogiri::HTML(open(url))
        doc.css('a').each do |link|  
            store_url("#{url}/#{link['href']}".gsub('http://','http:').gsub('//','/').gsub('http:','http://')) unless link['href'] =~ /^http/
        end  
    end
    puts "#{self.urls.count} url(s) grabbed"
  end
  
  protected

  def store_url(url)
    if self.urls.size < self.max_urls and !self.urls.include? url
      puts url
      self.urls << url
    end
  end

end
