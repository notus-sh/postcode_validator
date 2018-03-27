# frozen_string_literal: true

describe ZipcodeValidator do
  let(:countries) { load_data('validator')['countries'] }

  describe '#valid?' do
    it 'returns true for a valid zipcode' do
      countries.each do |country, zipcodes|
        zipcodes['valids'].shuffle.each do |zipcode|
          expect(subject.valid?(zipcode, country: country)).to be_truthy
        end
      end
    end

    it 'returns false for an invalid zipcode' do
      countries.each do |country, zipcodes|
        zipcodes['invalids'].shuffle.each do |zipcode|
          expect(subject.valid?(zipcode, country: country)).to be_falsey
        end
      end
    end

    it 'throws an Exception if called with an inexistant country code' do
      expect { subject.valid?('whatever', country: 'ZZ') }.to raise_error(ZipcodeValidator::Error)
    end
  end
end
