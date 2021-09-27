class CreateSiteusers < ActiveRecord::Migration[6.1]
  def change
    create_table :siteusers do |t|
      t.string :name
      t.string :email, null: false
      t.string :mobile
      t.string :address
      t.boolean :freelancer, default: false
      t.boolean :admin, default: false
      t.string :qualification
      t.text :experience
      t.string :industry
      t.boolean :approved, default: false
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
  end
end
