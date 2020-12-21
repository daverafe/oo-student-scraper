require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_index = Nokogiri::HTML(open(index_url))
    students = []
    student_index.css(".student-card").each do |student|
      student_hash = {  
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students << student_hash 
    end
    students 
  end

  def self.scrape_profile_page(profile_url)
    student_profile = Nokogiri::HTML(open(profile_url))
    profiles_hash = {}
    student_profile.css(".social-icon-container a").each do |profile|
      # binding.pry 
      if profile.attr("href").include?("twitter")
        profiles_hash[:twitter] = profile.attr("href")
      elsif profile.attr("href").include?("linkedin")
        profiles_hash[:linkedin] = profile.attr("href")
      elsif profile.attr("href").include?("github")
        profiles_hash[:github] = profile.attr("href")
      else
        profiles_hash[:blog] = profile.attr("href")
      end
    end
    # binding.pry
    profiles_hash[:profile_quote] = student_profile.css(".profile-quote").text
    profiles_hash[:bio] = student_profile.css(".description-holder p").text
    profiles_hash
  end

end


# :twitter => profile.css("div.social-icon-container a").attribute("href").value,
# :linkedin => profile.css("div.social-icon-container a").attribute("href").value,
# :github => profile.css("div.social-icon-container a").attribute("href").value,
# :blog => profile.css("div.social-icon-container a").attribute("href").value,
# :profile_quote => profile.css("div.vitals-text-container div.profile-quote").text,
# :bio => profile.css("div.bio-content.content-holder div.description-holder p").text



