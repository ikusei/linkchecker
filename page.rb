require 'digest/md5'
require 'rainbow'

class Page
  attr_accessor :url, :response_time, :response_code, :title, :meta, :referer, :description, :verbose
  
  def initialize(url,referer = "No Referer",verbose = false)
    self.url=url
    self.response_time  = 0
    self.response_code = 0
    self.title = "No title"
    self.description = "No description"
    self.referer = referer
    self.verbose = verbose 
  end
  
  def to_s
    response_code = self.response_code != "200" ? self.response_code.to_s.color(:red) : self.response_code.to_s.color(:green)
    title =  self.title == "No title" ? self.title.color(:red) : self.title
    
    output = "#{self.url}"
    output += " | #{self.referer}" if self.verbose
    output += " | #{self.response_time}s | #{response_code} | #{title} | #{description}"
  end
  
 
end