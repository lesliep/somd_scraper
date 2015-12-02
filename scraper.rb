require 'mechanize'
require 'active_support/core_ext/date'
require 'active_support/core_ext/numeric/time'

module SomdScraper

  def self.events(start_date: Date.current, end_date: Date.tomorrow)
    scraper = Scraper.new(start_date: start_date, end_date: end_date)
    scraper.events
  end

  class Scraper
    attr_reader :events
    def initialize(start_date:, end_date:)
      @mechanize = Mechanize.new
      @url = "http://www.somd.com/"
      @events = []

      (start_date..end_date).each do |d|
        @events.concat( get_events(d) )
      end
    end

    def get_events(date)
      date_string = event_date(date)
      page = @mechanize.get(@url + date_string )
      page.search("div.event").map { |event| event = Event.new(event, date) }
    end

    private 

    def event_date(date)
      day = date.day
      month = date.month
      year = date.year

      "calendar/?day=#{day}&year=#{year}&month=#{month}&calendar=&view_day=on"
    end
  end

  class Event
    attr_reader :title, :description, :details, :date
    def initialize(event, date)
      @event = event
      @date = date
      @title = get_title 
      @description = get_description 
      @details = get_details 

      remove_instance_variable(:@event)
    end

    private

    def get_title 
      format_string('.event-title')
    end

    def get_description 
      format_string('.event-body')
    end
    def get_details 
      details = format_string('.event-details').split("\n\t\t\t")
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

    def format_string(css_selector)
      @event.at(css_selector).text.encode('UTF-8', 'binary', invalid: :replace,
                                         undef: :replace, replace: '').strip
    end
  end
end
