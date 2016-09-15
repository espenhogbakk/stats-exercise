# Stats Exercise

This is an exercise exploring the ways to show some web analytics.

Some quick notes:

* MySQL engine MyISAM selected for faster read performance
* MD5 hashing of page view table columns in MySQL for faster inserts
* GET #top_referrers should be way faster, the current implementation uses
  way to many queries to be efficient.
* Because of indexes on `page_views` table seeding the database takes a
  *suuuuper* long time even when doing bulk inserts, so please have patience.

## Requirements

- MySQL running under local user (on OSX install with Homebrew)
- Ruby 2.3.1
- Bundler


## Setup

### Database initialization

Please don't use `rake db:setup`, since we have some migrations that aren't
reflected in the `schema.rb`. (A migration adding a trigger to create md5 hashes)
In the interest of saving some time, I didn't prioritize researching why...

    $ rake db:create
    $ rake db:migrate
    $ rake db:seed

Or...

    $ rake db:create db:migrate db:seed


### Run development server

    $ rails server

Then go to [http://localhost:3000](http://localhost:3000) to behold the data.


## Tests

    $ rake test
