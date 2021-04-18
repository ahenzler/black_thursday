require 'rspec'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/items'
require './lib/items_repo'
require './lib/merchants'
require './lib/merchants_repo'
require './lib/invoices'
require './lib/invoices_repo'

RSpec.describe SalesEngine do

  se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
  :invoices  => "./data/invoices.csv"
  })

  context 'it exists' do
    it 'exists' do
      expect(se).to be_instance_of(SalesEngine)
    end
  end

  context 'methods' do
    it 'has attributes' do
      expect(se.items).to be_instance_of(ItemRepo)
      expect(se.merchants).to be_instance_of(MerchantRepo)
      expect(se.invoices).to be_instance_of(InvoiceRepo)
      expect(se.analyst).to be_instance_of(SalesAnalyst)
    end
  end

end
