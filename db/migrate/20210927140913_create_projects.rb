class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.decimal :highest_pay
      t.string :payment_time_unit
      t.string :payment_currency
      t.boolean :bidding_closed, default: false
      t.references :creating_client, null: false, foreign_key: { to_table: :siteusers }
      t.references :awarded_freelancer, foreign_key: { to_table: :siteusers }

      t.timestamps
    end
  end
end
