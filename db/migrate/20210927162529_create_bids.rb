class CreateBids < ActiveRecord::Migration[6.1]
  def change
    create_table :bids do |t|
      t.references :bidding_user, null: false, foreign_key: { to_table: :siteusers }
      t.references :project, null: false, foreign_key: true
      t.text :description
      t.string :amount

      t.timestamps
    end
  end
end
