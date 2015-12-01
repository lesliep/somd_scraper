# SomdScraper

SomdScraper scrapes somd.com's calendar for events and crams them into an array
of easily digestable Event objects for Southern Maryland.
Southern Maryland, in case you were wondering, is a region consisting of three
Maryland counties: Calvert, Charles, and Saint Mary's. A short distance from
Washington D.C., these three counties have a combined population a little over
350,000 and share a unique culture.

## Usage

```ruby
require 'somd_scraper'

#pass in a Time object for the date you want events of
events = SomdScraper::events(Time.now)

```
Calling the scraper's events method will return an array of Event objects.
