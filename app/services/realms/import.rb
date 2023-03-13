# frozen_string_literal: true

class Realms::Import < ApplicationService
  attributes :token

  def call
    realms_response = HTTParty.get("https://eu.api.blizzard.com/data/wow/connected-realm/index?namespace=dynamic-eu&locale=en_GB&access_token=#{token}")

    realms_response['connected_realms'].each do |connected_realm|
      id = /connected-realm\/([0-9]+)/.match(connected_realm['href'])[1].to_i
      connected_realm_response = HTTParty.get("https://eu.api.blizzard.com/data/wow/connected-realm/#{id}?namespace=dynamic-eu&locale=en_GB&access_token=#{token}")

      realm = Realm.find_or_initialize_by(blizzard_id: id)
      next if realm.persisted?

      realm_response = connected_realm_response['realms'].count == 1 ? connected_realm_response['realms'].first : connected_realm_response['realms'].detect{|x| x['id'] == id}

      next if realm_response.blank?

      realm.assign_attributes(
        {
          name: realm_response['name'],
          region: realm_response['region']['name'],
          language: realm_response['category'],
          population: connected_realm_response['population']['name']
        }
      )

      realm.save
    end
  end
end
