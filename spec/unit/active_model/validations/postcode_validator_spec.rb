# frozen_string_literal: true

describe ActiveModel::Validations::PostcodeValidator do
  context 'with class methods' do
    subject(:model) { Class.new(TestModel) }

    it 'adds a validate method to ActiveModels' do
      expect(model).to respond_to(:validates_as_postcode)
    end

    # rubocop:disable RSpec/SubjectStub
    it 'integrates with ActiveModel validations' do
      options = { attributes: [:zipcode], country: 'US' }
      allow(model).to receive(:validates_with).with(described_class, options)
      model.validates :zipcode, postcode: { country: 'US' }

      expect(model).to have_received(:validates_with).with(described_class, options)
    end
    # rubocop:enable RSpec/SubjectStub

    it 'checks that all arguments are presents' do
      expect { model.validates_as_postcode :zipcode }.to raise_error(ArgumentError,
                                                                     ':country must be supplied')
    end

    it 'does not validates arguments when set' do
      expect { model.validates_as_postcode :zipcode, country: 'ZZ' }.not_to raise_error
    end
  end

  context 'when validated' do
    let(:countries) { load_fixtures('validator')['countries'] }

    describe 'with a static :country value' do
      it_behaves_like 'a correct validator for the given country' do
        subject { staticaly_validated_instance('StaticTestModel', :US) }

        let(:zipcodes) { countries['US'] }
      end
    end

    describe 'with a dynamic :country value' do
      it_behaves_like 'a correct validator for the given country' do
        subject { dynamicaly_validated_instance('DynamicTestModel', :US) }

        let(:zipcodes) { countries['US'] }
      end
    end

    describe 'with a wrong dynamic :country value' do
      subject(:record) { staticaly_validated_instance('NoCountryTestModel', :ZZ) }

      let(:zipcodes) { countries[countries.keys.sample] }

      it 'skips validation' do
        (zipcodes['valids'] + zipcodes['invalids']).shuffle.each do |postcode|
          record.zipcode = postcode
          expect(record).to be_valid
        end
      end
    end

    describe 'when used to validates postcodes for a country without postcodes' do
      it_behaves_like 'a correct validator for the given country' do
        subject { staticaly_validated_instance('NoPostcodeTestModel', :PA) }

        let(:zipcodes) { countries['PA'] }
      end
    end

    context 'when an error is found' do
      subject(:record) { staticaly_validated_instance('LocalizedTestModel', :CA) }

      around do |example|
        I18n.with_locale(locale) { example.run }
      end

      let(:locale) { %i[fr en].sample }

      it 'returns a localized error message' do
        record.zipcode = 'INVALID'
        record.valid?
        expect(record.errors[:zipcode]).to eq([I18n.t('errors.messages.invalid_postcode')])
      end
    end
  end
end
