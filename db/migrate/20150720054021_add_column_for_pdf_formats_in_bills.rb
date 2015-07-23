class AddColumnForPdfFormatsInBills < ActiveRecord::Migration
  def change
    add_column :bills, :pdf_format, :string
  end
end
