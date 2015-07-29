class CreateReferralTypes < ActiveRecord::Migration
  def change
    create_table :referral_types do |t|
      t.string :referral_type
      t.string :pricing

      t.timestamps
    end
  end
end
