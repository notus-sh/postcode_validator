# frozen_string_literal: true

describe PostcodeValidator do
  subject(:validator) { described_class.new }

  let(:countries) { load_fixtures('validator')['countries'] }

  describe '#valid?' do
    it 'returns true for a valid zipcode' do
      countries.each do |country, postcodes|
        postcodes['valids'].each do |postcode|
          expect(validator).to be_valid(postcode, country: country)
        end
      end
    end

    it 'returns false for an invalid zipcode' do
      countries.each do |country, postcodes|
        postcodes['invalids'].each do |postcode|
          expect(validator).not_to be_valid(postcode, country: country)
        end
      end
    end

    it 'throws an Exception if called with an inexistant country code' do
      expect { validator.valid?('whatever', country: 'ZZ') }.to raise_error(PostcodeValidator::Error)
    end
  end
end
