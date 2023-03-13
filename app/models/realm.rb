class Realm < ApplicationRecord
  searchkick

  def search_data
    {
      id: id,
      name: name
    }
  end
end
