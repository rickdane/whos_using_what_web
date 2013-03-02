class CreateAnewtables < ActiveRecord::Migration
  def change
    create_table :anewtables do |t|
      t.string :tablevalue

      t.timestamps
    end
  end
end
