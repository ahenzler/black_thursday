require_relative './customer'
require_relative './findable'
require 'time'
require 'csv'
require 'bigdecimal'

class CustomerRepo
  include Findable
  attr_reader :customer_list

  def initialize(csv_files, engine)
    @customer_list = customer_instances(csv_files)
    @engine = engine
  end

  def customer_instances(csv_files)
    customers = CSV.open(csv_files, headers: true, header_converters: :symbol)

    @customer_list = customers.map do |customer|
      Customer.new(customer, self)
    end
  end

  def all
    @customer_list
  end

  def find_by_id(id)
    find_by_id_repo(id, @customer_list)
  end

  def find_all_by_first_name(fragment)
    @customer_list.find_all do |customer|
      (customer.first_name).downcase.include?(fragment.downcase)
    end
  end

  def find_all_by_last_name(fragment)
    @customer_list.find_all do |customer|
      (customer.last_name).downcase.include?(fragment.downcase)
    end
  end

  def create(attributes)
    new_customer = Customer.new(attributes, self)
    find_max_id = @customer_list.max_by do |customer|
      customer.id
    end
    new_customer.id = (find_max_id.id + 1)
    customer_list << new_customer
  end

  def update(id, attributes)
    customer = find_by_id(id)
    if !customer.nil?
      customer.first_name = attributes[:first_name] unless attributes[:first_name].nil?
      customer.last_name = attributes[:last_name] unless attributes[:last_name].nil?
      customer.updated_at = Time.now
    end
    customer
  end

  def delete(id)
    customer = find_by_id(id)
    if customer_exists?(id)
      @customer_list.delete(customer)
    end
  end

  def customer_exists?(id)
    customer = find_by_id(id)
    customer != nil
  end
end
