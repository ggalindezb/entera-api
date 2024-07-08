require 'open-uri'

class CollegeApi
  DOMAIN = 'https://api.data.gov'.freeze
  API_ROUTE = '/ed/collegescorecard/v1'.freeze
  SEARCH_ENDPOINT = '/schools'.freeze

  class << self
    def search(...)
      new(...).search
    end
  end

  private_class_method :new

  attr_reader :name

  def initialize(school_name:)
    @school_name = school_name
  end

  def search
    return [] if @school_name.try(:size).to_i < 3

    params = {
      api_key: '048lbVyrQzMHJoNcryH1bSqtLULgpamI0rRmrxFa',
      :'school.name' => @school_name,
      fields: 'id,school.name,location'
    }

    uri = URI.parse("#{DOMAIN}#{API_ROUTE}#{SEARCH_ENDPOINT}")
    uri.query = URI.encode_www_form(params)
    data = JSON.parse(uri.read)['results']
    entries = data.select { |entry| entry['school.name'].match(/#{@school_name}/i) }
                  .map do |entry|
                    {
                      id: entry['id'],
                      name: entry['school.name'],
                      latitude: entry['location.lat'],
                      longitude: entry['location.lon'],
                    }
                  end
                  .sort_by { |entry| entry[:name].index(/#{@school_name}/i) }
  end
end
