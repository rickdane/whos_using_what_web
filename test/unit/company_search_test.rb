require 'test_helper'

class CompanySearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "that new works" do

    company = CompanySearch.new

    assert company is_a? Company

  end

end
