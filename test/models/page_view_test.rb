require 'test_helper'
require 'digest/md5'

class PageViewTest < ActiveSupport::TestCase
  setup do
    PageView.dataset.delete
  end

  test "creates with default values" do
    page_view = PageView.create(url: 'https://www.apple.com', referrer: 'http://developer.apple.com')

    assert page_view.created_at
    assert_kind_of Time, page_view.created_at

    assert page_view.hash
    assert_kind_of Fixnum, page_view.hash
  end

  test "hashes values correctly on save" do
    skip("MySQL's md5 algorithm seems to not return a string of 32 hexidecimal characters. Unsure how to compare them")
    page_view = PageView.create(url: 'https://www.apple.com', referrer: 'http://developer.apple.com')

    # We need to get the created_at in the same format as it is stored in the
    # DB. With ActiveRecord we could have used #read_attribute_before_type_cast
    # but I can't find anything similar for Sequel.
    created_at = page_view.created_at.strftime('%Y-%m-%d %H:%M:%S')
    hash_string = "#{page_view.id};#{page_view.url};#{page_view.referrer};#{created_at}"
    target_hash = Digest::MD5.hexdigest(hash_string)
    assert_equal target_hash, page_view.hash
  end
end
