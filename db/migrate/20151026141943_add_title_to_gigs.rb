class AddTitleToGigs < ActiveRecord::Migration
  def change
    add_column :gigs, :title, :string
  end
end
