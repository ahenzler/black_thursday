require 'rspec'
require 'bigdecimal'
require 'time'
require './lib/sales_engine'
require './lib/items'
require './lib/items_repo'
require './lib/merchants'
require './lib/merchants_repo'
require './lib/invoices'
require './lib/invoices_repo'

RSpec.describe InvoiceRepo do

  se = SalesEngine.from_csv({
  :invoices => "./data/invoices.csv",
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv"
  })
  invoice_repository = se.invoices

  context 'it exists' do
    it 'exists' do
      expect(invoice_repository).to be_instance_of(InvoiceRepo)
    end
  end

  context 'methods' do
    it 'can return all invoices' do
      expect(invoice_repository.all.class).to eq(Array)
      expect(invoice_repository.all.length).to eq(4985)
    end
    it "can find invoice by id" do
      expect(invoice_repository.find_by_id(12335938)).to be_instance_of(Invoice)
      expect(invoice_repository.find_by_id(192)).to eq(nil)
      expect(invoice_repository.find_by_id(12335938)).to eq(invoice_repository.invoice_list[0])
    end
  end
end
