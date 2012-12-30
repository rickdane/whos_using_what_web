class PersonSearch < ActiveRecord::Base
  attr_accessible :programming_language, :zipcode, :exclude_recruiters
end
