class PersonSearch < ActiveRecord::Base
  attr_accessible :programming_language, :page_number, :zipcode, :exclude_recruiters

end
