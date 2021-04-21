require './lib/sales_analyst'
require './lib/sales_engine'
require './lib/items'
require './lib/merchants'
require './items_repo'
require './merchants_repo'
require './invoices'
require './invoices_repo'
require 'rspec'

RSpec.describe SalesAnalyst do

  se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
  :invoices  => "./data/invoices.csv",
  :invoice_items => "./data/invoice_items.csv",
  :transactions => "./data/transactions.csv",
  :customers => "./data/customers.csv"
  })
  sales_analyst = se.analyst

  context 'Instanstiation' do
    it 'exists' do
      expect(sales_analyst).to be_instance_of(SalesAnalyst)
    end
  end

  context 'methods' do
    it 'can return average items per merchant' do
      expect(sales_analyst.average_items_per_merchant).to eq(2.88)
    end

    it 'can return standard deviation of items per merchant' do
      expect(sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
    end

    it "can return merchants with the most items" do
      sales_analyst.stub(:merchant_ids_with_high_item_count).and_return([12334123, 12334145, 12334146, 12334159, 12334194, 12334195, 12334202, 12334228, 12334365, 12334397, 12334403, 12334420, 12334455, 12334478, 12334516, 12334522, 12334601, 12334609, 12334614, 12334727, 12334788, 12334812, 12334814, 12334815, 12334863, 12334951, 12334984, 12334986, 12334994, 12335215, 12335402, 12335480, 12335504, 12335747, 12335805, 12335807, 12335842, 12335856, 12335857, 12335877, 12335938, 12335947, 12335963, 12336081, 12336086, 12336094, 12336161, 12336342, 12336389, 12336477, 12336515, 12336965])

      expected = sales_analyst.merchants_with_high_item_count

      expect(expected.length).to eq(52)
      expect(expected.first.class).to eq(Merchant)
      expect(expected.class).to eq(Array)
    end

    it 'can find the average price of a merchants items' do

      expect(sales_analyst.average_item_price_for_merchant(12334105).class).to eq(BigDecimal)
      expect(sales_analyst.average_item_price_for_merchant(12334105)).to eq(0.1666e2)
    end

    it 'can find the average of average price' do
      expect(sales_analyst.average_average_price_per_merchant.class).to eq(BigDecimal)
      expect(sales_analyst.average_average_price_per_merchant).to eq(0.35029e3)
    end

    it 'can return items 2 standard deviations above average item price' do
      expect(sales_analyst.golden_items.class).to eq(Array)
      expect(sales_analyst.golden_items.length).to eq(5)
    end

    it 'can return average invoices per merchant' do
      expect(sales_analyst.average_invoices_per_merchant).to eq(10.49)
    end

    it 'can return average invoice per merchant with standard deviation' do
      expect(sales_analyst.average_invoices_per_merchant_standard_deviation).to eq(3.29)
    end

    it 'can return which merchants are two standard deviations above the average' do
      sales_analyst.stub(:merchant_ids_with_high_invoice_count).and_return([12334141, 12334146, 12334176, 12334183, 12334634, 12334942, 12335204, 12335213, 12335329, 12335417, 12336266, 12336430])

      expect(sales_analyst.top_merchants_by_invoice_count.class).to eq(Array)
      expect(sales_analyst.top_merchants_by_invoice_count.length).to eq(12)
      expect(sales_analyst.top_merchants_by_invoice_count.first.class).to eq(Merchant)
    end

    it 'can return which merchants are two standard deviations below the average' do
      sales_analyst.stub(:merchant_ids_with_low_invoice_count).and_return([12334235, 12334601, 12335000, 12335560])

      expect(sales_analyst.bottom_merchants_by_invoice_count.class).to eq(Array)
      expect(sales_analyst.bottom_merchants_by_invoice_count.length).to eq(4)
      expect(sales_analyst.bottom_merchants_by_invoice_count.first.class).to eq(Merchant)
    end

    it 'can return top days by invoice count' do
      expect(sales_analyst.top_days_by_invoice_count).to eq(["Wednesday"])
    end

    it 'can return percentage of invoices matching a status' do
      expect(sales_analyst.invoice_status(:pending)).to eq(29.55)
      expect(sales_analyst.invoice_status(:shipped)).to eq(56.95)
      expect(sales_analyst.invoice_status(:returned)).to eq(13.5)
    end

    it 'can see if paid in full ' do
      expect(sales_analyst.invoice_paid_in_full?(2179)).to eq(true)
      expect(sales_analyst.invoice_paid_in_full?(1752)).to eq(false)
    end

    it 'can get the total of the invoice' do
      expect(sales_analyst.invoice_total(46)).to eq(BigDecimal(98668)/100)
      expect(sales_analyst.invoice_total(46).class).to eq(BigDecimal)
    end

    xit 'can return the total revenue at a given date' do
      expect(sales_analyst.total_revenue_by_date(Time.parse("2009-02-07"))).to eq(21067.77)
    end

    xit 'can return top revenue earners by given number' do
      expected = sales_analyst.top_revenue_earners(3)
      expect(expected.class).to eq(Array)
      expect(expected.first.class).to eq(Merchant)
      expect(expected.first.id).to eq(12334634)
    end

    it 'can return top revenue earners top 20' do
      expected = sales_analyst.top_revenue_earners
      expect(expected.class).to eq(Array)
      expect(expected.first.class).to eq(Merchant)
      expect(expected.first.id).to eq(12334634)
      expect(expected.length).to eq(20)
    end

    xit 'can return merchants with pending invoices' do
      expect(sales_analyst.merchants_with_pending_invoices.length).to eq(467)
      expect(sales_analyst.merchants_with_pending_invoices.first.class).to eq(Merchant)
    end

    xit 'can return merchants with one item' do
      expected = sales_analyst.merchants_with_only_one_item

      expect(expected.length).to eq 243
      expect(expected.first.class).to eq Merchant
    end

  end
end
