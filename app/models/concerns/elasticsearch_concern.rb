module Concerns::ElasticsearchConcern
	extend ActiveSupport::Concern

	included do
		ELASTICSEARCH_MAX_RESULTS = 25

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    include Elasticsearch::Model::Indexing

    mapping do
      indexes :location, type: 'geo_point'
	    indexes :city,     type: 'text'
	    indexes :state,    type: 'text'
	    indexes :acc_number, type: 'text'
	    indexes :acc_balance, type: 'float'
    end

    def self.search(query = nil, options = {})
	    options ||= {}

	    # empty search not allowed, for now
	    return nil if query.blank? && options.blank?

	    # define search definition
	    search_definition = {
	      query: {
	        bool: {
	          must: []
	        }
	      }
	    }

	    unless options.blank?
	      search_definition[:from] = 0
	      search_definition[:size] = ELASTICSEARCH_MAX_RESULTS
	    end

	    # query
	    if query.present?
	      search_definition[:query][:bool][:must] << {
	        multi_match: {
	          query: query,
	          fields: %w(city state),
	          operator: 'and'
	        }
	      }
	    end

	    # geo spatial
	    if options[:lat].present? && options[:lon].present?
	      options[:distance] ||= 100

	      search_definition[:query][:bool][:must] << {
	        filtered: {
	          filter: {
	            geo_distance: {
	              distance: "#{options[:distance]}mi",
	              location: {
	                lat: options[:lat].to_f,
	                lon: options[:lon].to_f
	              }
	            }
	          }
	        }
	      }
	    end

	    __elasticsearch__.search(search_definition)
	  end


    def as_indexed_json(_options = {})
	    as_json(only: %w(acc_number acc_balance city state))
	      .merge(location: {
	        lat: lat.to_f, lon: lon.to_f
	      })
	  end
  end
end