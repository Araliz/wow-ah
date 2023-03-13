# frozen_string_literal: true

# ProductInventory.searchkick_index.store() to add single element to index

class Auction
  include ActiveModel::Model

  searchkick

  attr_accessor :id,
                :item_id,
                :bid,
                :buyout,
                :time_left,
                :quantity,
                :realm_name

  def self.search_import
    Auction
  end

  def search_data
    {
      id: id,
      item_id: item_id,
      bid: bid,
      buyout: buyout,
      time_left: time_left,
      quantity: quantity,
      realm_name: realm_name
    }
  end

  def destroyed?
    false
  end

  def self.class
    self
  end

  def self.instance
    self
  end

  def self.all
    token = Oauth::GetToken.call.result
    auctions = []

    Realm.all.each do |realm|
      response = HTTParty.get("https://eu.api.blizzard.com/data/wow/connected-realm/#{realm.blizzard_id}/auctions?namespace=dynamic-eu&locale=en_GB&access_token=#{token}")

      auctions << response['auctions'].map do |auction|
        Auction.new(
          id: auction['id'],
          item_id: auction['item']['id'],
          bid: auction['bid'],
          buyout: auction['buyout'],
          time_left: auction['time_left'],
          quantity: auction['quantity'],
          realm_name: realm.name
        )
      end
    end

    auctions.flatten.compact
  end

  def self.should_index?
    true
  end
end
