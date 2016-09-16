class PageView < Sequel::Model
  # id          :integer(11)  not null, primary key
  # url         :varchar      not null
  # referrer    :varchar      null
  # created_at  :datetime     not null, default: current_timestamp
  # hash        :varchar      not null, default: md5(concat_ws(id;url;referrer;created_at))

  # Note: We do the hashing in the database instead of in Ruby so that we can
  # make use of the faster inserts given to us by accessing the DB directly.
  # This is especially useful when loading the large dummy dataset.

  dataset_module do
    def last_days(num_days)
      num_days -= 1
      where(created_at: (num_days.days.ago.beginning_of_day..Time.now))
    end

    # Returns top urls for the past 5 days
    def top_urls
      last_days(5)
      .select{[ created_at.cast(Date).as(:date), :url, count(:url).as(:visits)]}
      .group(:date, :url)
    end

    # Returns the top N number of urls for a given date
    def top_n_urls_for_date(limit, date)
      where(created_at: (date.beginning_of_day..date.end_of_day))
      .select{[ created_at.cast(Date).as(:date), :url, count(:url).as(:visits)]}
      .group(:url)
      .order(:visits)
      .reverse
      .limit(limit)
    end

    def top_n_referrers_for_url_and_date(limit, url, date)
      select {[
        :referrer,
        count(:url).as(:visits),
      ]}
      .group(:referrer, :url)
      .where(
        created_at: (date.beginning_of_day..date.end_of_day),
        url: url
      )
      .exclude(referrer: nil)
      .order(:visits)
      .reverse
      .limit(limit)
    end
  end
end
