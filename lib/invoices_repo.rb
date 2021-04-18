require_relative './invoices'
require 'time'
require 'csv'
require 'bigdecimal'

class InvoiceRepo
  attr_reader :invoice_list

  def initialize(csv_files, engine)
    @invoice_list = invoice_instances(csv_files)
    require'pry';binding.pry
    @engine    = engine
  end

  def invoice_instances(csv_files)
    invoices = CSV.open(csv_files, headers: true,
    header_converters: :symbol)

    @invoice_list = invoices.map do |invoice|
      Invoice.new(invoice, self)
    end
  end
end
