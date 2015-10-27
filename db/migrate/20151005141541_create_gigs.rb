class CreateGigs < ActiveRecord::Migration
  def change
    create_table :gigs do |t|
      t.string :artist
      t.string :place
      t.date :gig_date

      t.timestamps null: false
    end
  end
end
