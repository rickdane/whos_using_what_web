class CreateCompanySearches < ActiveRecord::Migration
  def change
    create_table :company_searches do |t|
      t.string :location
      t.string :keyword

      t.timestamps
    end
  end
end
