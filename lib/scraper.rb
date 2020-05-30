require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)

    info = []
    page = Nokogiri::HTML(open(index_url))
    student = page.css(".student-card")
    student.each do |card|
      info << {:name => card.css("h4").text, :location => card.css("p").text, :profile_url => card.css("a")[0]["href"]}
    end
    info
  end

  def self.scrape_profile_page(profile_url)
    doc=Nokogiri::HTML(open(profile_url))

    student_profile = {}

    doc.css("div.social-icon-container a").each do |link_xml|
      case link_xml.attribute("href").value
      when /twitter/
        student_profile[:twitter] = link_xml.attribute("href").value
      when /github/
        student_profile[:github] = link_xml.attribute("href").value
      when /linkedin/
        student_profile[:linkedin] = link_xml.attribute("href").value
      else
        student_profile[:blog] = link_xml.attribute("href").value
      end
    end


    student_profile[:profile_quote] = doc.css("div.profile-quote").text
    student_profile[:bio] = doc.css("div.description-holder p").text 
    student_profile
  end

end

