#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'page'
require 'optparse'

class LinkChecker
  attr_accessor :pages, :max_urls, :verbose
  options = {}

  def initialize(url = "http://www.google.com")
    self.pages = [ Page.new(url) ]
    self.max_urls = 10
  end

  def stats
    self.pages.each_with_index do |page,i|
      begin
        start = Time.now
        response = open(page.url)
        page.response_code = response.status[0]
        page.response_time = Time.now - start
      rescue Exception  => e
        page.response_code = "404"
      end
      puts page
    end
  end

  def grab
    self.pages.each do |page|
      doc = Nokogiri::HTML(open(page.url))
      page.title =  doc.css("title").text
      page.description =  doc.at('//meta[@name="description"]')['content']
      doc.css('a').each do |link|  
        unless link['href'] =~ /^http/
          if link['href'] && link['href'][0] == 47
            store_url("#{self.homepage.url}/#{link['href'][/.(.*)/m,1]}",page.url) 
          else 
            store_url("#{page.url}/#{link['href']}",page.url) 
          end
        end
      end
    end
  end

  def homepage
    self.pages.first
  end

  protected

  def store_url(url,referer)
    if self.pages.size < self.max_urls and !self.pages.collect {|p| p.url }.include? url
      self.pages << Page.new(url,referer)
    end
  end



  ARGV.options do |opts|
    opts.banner = "Usage: linkchecker [website]"
    opts.on("-m", "--max [MAX]", "Maximum of links to follow", "Default: 10") do |max|
      options['max'] =  max
    end


    opts.on("-v", "--verbose", "Outputs some useless informations") do |v|
      options['verbose'] = true
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
      puts opts
      exit
    end

    opts.parse!
    checker = LinkChecker.new(ARGV.pop)
    checker.verbose = true if options['verbose']
    checker.max_urls = options['max'].to_i
    checker.grab
    checker.stats
  end


end
