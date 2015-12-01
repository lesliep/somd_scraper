require 'mechanize'

module SomdScraper

  def self.events(start_date: Time.now)
    scraper = Scraper.new(date)
    scraper.events
  end

  class Scraper
    def initialize(date)
      @mechanize = Mechanize.new
      @url = "http://www.somd.com/"
      @date = event_date(day: date.day, month: date.month, year: date.year)
    end
    def events
      page = @mechanize.get(@url + event_date)
      page.search("div.event").map { |event| event = Event.new(event) }
    end

    private 

    def event_date(day: Time.now.day, month: Time.now.month, year: Time.now.year)
      "calendar/?day=#{day}&year=#{year}&month=#{month}&calendar=&view_day=on"
    end
  end

  class Event
    attr_reader :title, :description, :details
    def initialize(event)
      @title = get_title event
      @description = get_description event
      @details = get_details event
    end

    def start_time
      hour = @details[:time]
      minutes = 0
      @start_time ||= @d
    end

    def end_time
    end

    private

    def get_title event
      event.at('.event-title').text.strip
    end

    def get_description event
      event.at('.event-body').text.strip
    end
    def get_details event
      details = event.at('.event-details').text.strip.split("\n\t\t\t")
      parse_details details
    end

    def parse_details details
      re = /([a-z ]+):\W*(.+)/i
      details_hash = {}
      details.each do |detail|
        results = re.match detail
        details_hash[results[1].downcase.sub(' ','').to_sym] = results[2].strip
      end
      details_hash
    end
  end
end
