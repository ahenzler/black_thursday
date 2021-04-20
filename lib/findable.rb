module Findable
  def find_by_id_repo(id, repo)
    repo.find do |instance|
      instance.id == id
    end
  end

  def find_all_by_item_id_repo(item_id, repo)
    repo.find_all do |instance|
      instance.item_id == item_id
    end
  end

  def find_all_by_merchant_id_repo(merchant_id, repo)
    repo.find_all do |instance|
      instance.merchant_id == merchant_id
    end
  end

  def find_all_by_invoice_id_repo(invoice_id, repo)
    repo.find_all do |instance|
      instance.invoice_id == invoice_id
    end
  end

end
