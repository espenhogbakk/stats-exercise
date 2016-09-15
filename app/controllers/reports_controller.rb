class ReportsController < ApplicationController
  # Returns the number of page views per URL, grouped by day, for the past 5
  # days.
  def top_urls
    # Group results by date, and remove date from result
    @results = PageView.top_urls.to_a
      .group_by { |group| group[:date] }
      .each { |_, value| value.map!{ |site| site.to_hash.except(:date) }}

    # We could use a templating system like jbuilder, but it didn't really make
    # sense for this exercise
    render json: @results
  end

  # Returns the top 5 referrers for the top 10 urls grouped by day, for the
  # past 5 days
  def top_referrers
    results = {}

    # Get list of last 5 days
    dates = (5.days.ago.to_date..Date.today).to_a

    # Sadly we have to loop through all the days (and the urls) and do several
    # queries. I would prefer to do everything in one single query, but I
    # couldn't figure out a way to do it. Seems like PostgreSQLs Window
    # functions might be of help here, but since we are using MySQL which
    # doesn't support it we are out of luck.
    #
    # I'm sure this is another clever way to do this, maybe with 2 queries,
    # one for top urls, and one for top referrers, and then merge the data
    # somehow. But it seems that my SQL skills don't suffice.
    for date in dates
      PageView
        .top_n_urls_for_date(10, date)
        .each do |result|
          url = result.to_hash.slice(:url, :visits)

          ## Find top referrers for this url on this date
          PageView
            .top_n_referrers_for_url_and_date(5, url[:url], date)
            .each do |result|
              url['referrers'] ||= []
              url['referrers'].push({
                url: result[:referrer],
                visits: result[:visits]
              })
            end

          results[date] ||= []
          results[date].push(url)
        end
    end

    @results = results

    render json: @results
  end
end
