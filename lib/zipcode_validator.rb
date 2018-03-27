# frozen_string_literal: true

require 'zipcode_validator/version'
require 'twitter_cldr'

# A simple ZIP-code validator
#
# Can be used to validate a post code, regarding a country specified through the
# :country option as an ISO-3166-2 code.
class ZipcodeValidator
  # Package specific error class
  class Error < StandardError; end

  def valid?(zip_code, options = {})
    iso_code = country_as_iso(options)
    zip_code = zip_code.to_s.strip
    postal_codes = postal_codes_for(iso_code)
    postal_codes ? postal_codes.valid?(zip_code) : zip_code.blank?
  end

  protected

  def country_as_iso(options)
    raise Error, 'Missing :country option' unless options.key?(:country) && !options[:country].nil?
    iso = TwitterCldr::Shared::Territories.normalize_territory_code(options[:country])

    # raise ArgumentError if :iso is not a valid territory code
    iso if TwitterCldr::Shared::TerritoriesContainment.contains?('001', iso.to_s.upcase)
  rescue ArgumentError => e
    raise Error, e.message
  end

  def postal_codes_for(iso_code)
    TwitterCldr::Shared::PostalCodes.for_territory(iso_code)
  rescue TwitterCldr::Shared::InvalidTerritoryError
    # No validator exists for :iso_code, this country may not use postcodes at all.
    nil
  end
end
