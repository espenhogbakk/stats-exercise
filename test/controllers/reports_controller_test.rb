require 'test_helper'

def create_page_view created_at
end

class ReportsControllerTest < ActionDispatch::IntegrationTest
  url = 'http://apple.com'
  referrer = 'http://facebook.com'
  dates = (11.days.ago.to_date..Date.today)

  setup do
    PageView.dataset.delete

    # Populate the database with some page views
    dates.each do |date|
      PageView.create(url: url, referrer: referrer, created_at: date)
    end
  end

  test "should get top urls" do
    get top_urls_url
    assert_response :success
  end

  test "should return top urls in JSON" do
    get top_urls_url

    json = JSON.parse(response.body)
    assert_equal json[dates.last.to_s], ["url" => url, "visits" => 1]
    assert_equal 5, json.length
  end

  test "should get top referrers" do
    get top_referrers_url
    assert_response :success
  end

  test "should return top referrers in JSON" do
    get top_referrers_url

    json = JSON.parse(response.body)

    assert_equal json[dates.last.to_s], [
      "url" => url,
      "visits" => 1,
      "referrers" => [{
        "url" => referrer, "visits" => 1
      }]
    ]
    assert_equal 5, json.length
  end
end
