require 'test_helper'

def create_page_view created_at
end

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    PageView.dataset.delete
  end

  test "should get top urls" do
    get top_urls_url
    assert_response :success
  end

  test "should return top urls in JSON" do
    date = Date.today
    page_view = PageView.create(url: 'http://apple.com', referrer: 'http://facebook.com', created_at: date)

    get top_urls_url

    json = JSON.parse(response.body)
    assert_equal json[date.to_s], ["url" => page_view.url, "visits" => 1]
  end

  test "should get top referrers" do
    get top_referrers_url
    assert_response :success
  end

  test "should return top referrers in JSON" do
    dates = (11.days.ago.to_date..Date.today)
    url = 'http://apple.com'
    referrer = 'http://facebook.com'
    dates.each do |date|
      PageView.create(url: url, referrer: referrer, created_at: date)
    end

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
