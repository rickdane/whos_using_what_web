class PersonSearch < ActiveRecord::Base
  attr_accessible :programming_language, :zipcode, :exclude_recruiters, :page_number

end
