require 'test_helper'

class AnewtableTest < ActiveSupport::TestCase
  test "the truth" do
    company = Anewtable.new

    assert company.is_a? Anewtable
  end
end
