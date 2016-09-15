PAGE_VIEWS = 1000000 # Number of page views we want to seed our db with
BULK_SIZE = 10000 # Number of records to insert into db in one transaction

# Since report #2 need to have at least 10 urls, and 5 referrers I added a
# couple of other urls than what was given in the instructions.
URLS = [
  'http://apple.com',
  'https://apple.com',
  'https://www.apple.com',
  'http://developer.apple.com',
  'http://en.wikipedia.org',
  'http://opensource.org',
  'https://facebook.com',
  'https://www.facebook.com',
  'https://google.com',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
]

REFERRERS = [
  'http://apple.com',
  'https://apple.com',
  'https://www.apple.com',
  'http://developer.apple.com',
  'https://facebook.com',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  nil
]

DATES = (60.days.ago.to_date..Date.today).map{ |date| date.to_datetime }

DB = PageView.db # Sequel DB connection

# Clear out all data before we add more so that we are sure we always end up
# with the same amount of test data
PageView.dataset.delete

# Imports an array of page views into the database
#
# bulk - An Array of hashes representing a page view
def db_import(bulk)
  DB[:page_views].import(
    [
      :url,
      :referrer,
      :created_at,
    ], bulk
  )
end

# Create test data
bulk = [];
counter = 0
PAGE_VIEWS.times do
  # Array#sample ensures that we have at least 1 one of each in the array we
  # are sampling
  bulk.push([
    URLS.sample,
    REFERRERS.sample,
    DATES.sample,
  ])
  counter += 1

  if (counter % BULK_SIZE == 0)
    # Use import to effiecently insert records in bulk
    db_import bulk
    bulk = [] # Reset bulk
  end
end

# If we have remaining items, insert them as well
if (counter % BULK_SIZE != 0)
  db_import bulk
end
