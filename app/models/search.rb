class Search

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :zipcode, :programming_language

  #just needed for non-active-record form
  def persisted?

  end

end
