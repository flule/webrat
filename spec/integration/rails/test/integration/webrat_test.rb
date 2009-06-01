require 'test_helper'

class WebratTest < ActionController::IntegrationTest

  #Firefox raises a security concern under Selenium
  unless ENV['WEBRAT_INTEGRATION_MODE'] == 'selenium'
    test "should visit fully qualified urls" do
      visit root_url(:host => "chunkybacon.example.com")
      assert_equal "chunkybacon", request.subdomains.first
    end
  end

  test "should visit pages" do
    visit root_path
    assert_contain("Webrat Form")
    assert URI.parse(current_url).path, root_path
  end

  test "should submit forms" do
    visit root_path
    fill_in "Text field", :with => "Hello"
    check "TOS"
    select "January"
    click_button "Test"
  end

  test "should check the value of a field" do
    visit "/"
    assert field_labeled("Prefilled").value, "text"
  end

  test "should not carry params through redirects" do
    visit before_redirect_form_path
    fill_in "Text field", :with => "value"
    click_button

    assert response.body !~ /value/
    assert response.body =~ /custom_param/
  end

  test "should follow internal redirects" do
    visit internal_redirect_path
    assert !response.redirect?
    assert response.body.include?("OK")
  end

  test "should not follow external redirects" do
    visit external_redirect_path
    assert response.redirect?
  end

  test "should be able to assert xpath" do
    visit root_path
    assert_have_xpath "//h1"
  end

  test "should be able to assert selector" do
    visit root_path
    assert_have_selector "h1"
  end

  # Firefox detects and prevents infinite redirects under Selenium
  unless ENV['WEBRAT_INTEGRATION_MODE'] == 'selenium'
     test "should detect infinite redirects" do
       assert_raises Webrat::InfiniteRedirectError do
         visit infinite_redirect_path
       end
    end
  end

#  test "should be able to assert have tag" do
#    visit root_path
#    assert_have_tag "h1"
#  end
end
