module Findable

  def find_by_id_repo(id, types)
    types.find do |type|
      type.id == id
    end
  end

end
