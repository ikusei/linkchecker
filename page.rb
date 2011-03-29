require 'digest/md5'
require 'rainbow'

class Page
  attr_accessor :url, :response_time, :response_code, :title, :meta, :referer
  
  def initialize(url,referer = "No Referer")
    self.url=url
    self.response_time  = 0
    self.response_code = 0
    self.title = "No title"
    self.referer = referer 
  end
  
  def to_s
    response_code = self.response_code != "200" ? self.response_code.to_s.color(:red) : self.response_code.to_s.color(:green)
    title =  self.title == "No title" ? self.title.color(:red) : self.title
    "#{self.url} | #{self.referer} | #{self.response_time}s | #{response_code} | #{title}"
  end
  
 
end