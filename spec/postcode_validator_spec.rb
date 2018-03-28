# frozen_string_literal: true

describe ::PostcodeValidator do
  let(:countries) { load_data('validator')['countries'] }

  describe '#valid?' do
    it 'returns true for a valid zipcode' do
      countries.each do |country, postcodes|
        postcodes['valids'].shuffle.each do |postcode|
          expect(subject.valid?(postcode, country: country)).to be_truthy
        end
      end
    end

    it 'returns false for an invalid zipcode' do
      countries.each do |country, postcodes|
        postcodes['invalids'].shuffle.each do |postcode|
          expect(subject.valid?(postcode, country: country)).to be_falsey
        end
      end
    end

    it 'throws an Exception if called with an inexistant country code' do
      expect { subject.valid?('whatever', country: 'ZZ') }.to raise_error(PostcodeValidator::Error)
    end
  end
end
