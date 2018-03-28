# frozen_string_literal: true

require 'twitter_cldr'

begin
  # ActiveModel integration
  require 'active_model'
  require 'active_support/i18n'
  require 'active_model/validations/postcode_validator'

  ActiveSupport.on_load(:i18n) do
    I18n.load_path << Dir[File.expand_path(File.join(__dir__, '..', 'locales', '*.yml')).to_s]
  end
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

# A simple  postcode validator
#
# Can be used to validate a post code, regarding a country specified through the
# :country option as an ISO-3166-2 code.
class PostcodeValidator
  # Package specific error class
  class Error < StandardError; end

  def valid?(postcode, options = {})
    iso = country_as_iso(options)
    postcode = postcode.to_s.strip
    validator = validator_for(iso)
    validator ? validator.valid?(postcode) : postcode.blank?
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

  def validator_for(iso)
    TwitterCldr::Shared::PostalCodes.for_territory(iso)
  rescue TwitterCldr::Shared::InvalidTerritoryError
    # No validator exists for :iso_code, this country may not use postcodes at all.
    nil
  end
end
