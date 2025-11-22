require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "h1", "Company Search"
  end

  test "should search companies" do
    get root_url, params: { query: "Lisboa" }
    assert_response :success
    assert_select ".list-group-item", minimum: 1
  end

  test "should show no results message for non-matching search" do
    get root_url, params: { query: "NonExistentCompany123" }
    assert_response :success
    assert_select ".alert-info", text: /No companies found/
  end

  test "should get admin page" do
    get admin_companies_url
    assert_response :success
    assert_select "h1", "Import Companies"
  end

  test "should show error when importing without file" do
    post import_companies_url
    assert_redirected_to admin_companies_url
    follow_redirect!
    assert_select ".alert-danger", text: /Please select a file/
  end

  test "should limit search results to 100" do
    # Create 150 companies
    150.times do |i|
      Company.create!(
        coc_number: "1000#{i}",
        company_name: "Test Company #{i}",
        city: "TestCity"
      )
    end

    get root_url, params: { query: "Test" }
    assert_response :success
    # Should show max 100 results
    assert_select ".list-group-item", maximum: 100
  end
end
