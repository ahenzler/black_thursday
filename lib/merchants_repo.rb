require_relative './merchants'
require_relative './findable'
require 'csv'

class MerchantRepo
  include Findable
  attr_reader :merchants_list

  def initialize(csv_files, engine)
    @merchants_list = merchant_instances(csv_files)
    @engine         = engine
  end

  def find_items_by_id(id)
    @engine.find_items_by_id(id)
  end

  def merchant_instances(csv_files)
    merchants = CSV.open(csv_files, headers: true,
    header_converters: :symbol)

    @merchants_list = merchants.map do |merchant|
      Merchant.new(merchant, self)
    end
  end

  def all
    @merchants_list
  end

  def find_by_id(id)
    find_by_id_repo(id, @merchants_list)
  end

  def find_by_name(name)
    @merchants_list.find do |merchant|
      (merchant.name).downcase == name.downcase
    end
  end

  def find_all_by_name(fragment)
    @merchants_list.find_all do |merchant|
      (merchant.name).downcase.include?(fragment.downcase)
    end
  end

  def create(attributes)
    new_merchant = Merchant.new(attributes, self)
    find_max_id = @merchants_list.max_by do |merchant|
      merchant.id
    end
    new_merchant.id = (find_max_id.id + 1)
    merchants_list << new_merchant
  end

  def merchant_exists?(id)
    merchants = find_by_id(id)
    merchants != nil
  end

  def update(id, attributes)
    merchant = find_by_id(id)
    if merchant_exists?(id)
      merchant.name = attributes[:name]
    end
  end

  def delete(id)
    merchant = @merchants_list.find do |merchant|
      merchant.id == id
    end
    @merchants_list.delete(merchant)
  end

  def merchant_id_array
    @merchants_list.map do |merchant|
      merchant.id
    end
  end

end
