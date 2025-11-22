require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "should not save company without coc_number" do
    company = Company.new(company_name: "Test Company", city: "Lisboa")
    assert_not company.save, "Saved the company without a CoC number"
  end

  test "should not save company without company_name" do
    company = Company.new(coc_number: "12345678", city: "Lisboa")
    assert_not company.save, "Saved the company without a company name"
  end

  test "should not save company without city" do
    company = Company.new(coc_number: "12345678", company_name: "Test Company")
    assert_not company.save, "Saved the company without a city"
  end

  test "should not save duplicate coc_number" do
    company = Company.new(
      coc_number: companies(:sonae).coc_number,
      company_name: "Duplicate Company",
      city: "Porto"
    )
    assert_not company.save, "Saved company with duplicate CoC number"
  end

  test "should save valid company" do
    company = Company.new(
      coc_number: "99999999",
      company_name: "New Company",
      city: "Faro"
    )
    assert company.save, "Failed to save valid company"
  end

  test "search should find companies by name" do
    results = Company.search("Sonae")
    assert_includes results, companies(:sonae)
  end

  test "search should find companies by city" do
    results = Company.search("Maia")
    assert_includes results, companies(:sonae)
  end

  test "search should find companies by coc_number" do
    results = Company.search("500278389")
    assert_includes results, companies(:sonae)
  end

  test "search should be case insensitive" do
    results = Company.search("LISBOA")
    assert_includes results, companies(:galp)
  end

  test "search should return all companies when query is blank" do
    results = Company.search("")
    assert_equal Company.count, results.count
  end

  test "search should return no results for non-matching query" do
    results = Company.search("XYZ123NonExistent")
    assert_empty results
  end
end
