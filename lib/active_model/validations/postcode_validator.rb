# frozen_string_literal: true

require 'active_model/validations'

module ActiveModel
  module Validations
    class PostcodeValidator < ActiveModel::EachValidator # :nodoc:
      def validate_each(record, attribute, value)
        country = option_call(record, :country)
        record.errors.add(attribute, :invalid_postcode) unless validator.valid?(value, country: country)
      rescue ::PostcodeValidator::Error
        # When :country is not a valid country, just skip postcode validation
        # :country validation is developer's responsability
      end

      def check_validity!
        raise ArgumentError, ':country must be supplied' unless options.include?(:country)
      end

      private

      def option_call(record, name)
        option = options[name]
        option.respond_to?(:call) ? option.call(record) : option
      end

      def validator
        @validator ||= ::PostcodeValidator.new
      end
    end

    module HelperMethods # :nodoc:
      # Validates whether the value of the specified attribute is a valid zip code
      #
      #   class Address < ActiveRecord::Base
      #
      #     validates_as_postcode :zipcode, country: :US
      #
      #     validates :post_code,
      #       presence: true,
      #       postcode: { allow_nil: true, country: -> { |record| record.country_code } }
      #   end
      #
      # Configuration:
      # * <tt>:country</tt> - The ISO-3166-2 code of the country we will validate
      #   the zip code for. Can be a static value or a lambda that may accept the
      #   current record as its first argument.
      def validates_as_postcode(*attr_names)
        validates_with PostcodeValidator, _merge_attributes(attr_names)
      end
    end
  end
end
