class ChangeBankAccNumberToString < ActiveRecord::Migration
  def change
    change_column :bankdetails, :bank_account_number, :string
  end
end
