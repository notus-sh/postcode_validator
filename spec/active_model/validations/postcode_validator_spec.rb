# frozen_string_literal: true

require 'helpers/active_model_helper'

describe ActiveModel::Validations::PostcodeValidator do
  context 'on class level' do
    subject { Class.new(TestModel) }

    it 'integrates well with ActiveModels' do
      expect(subject).to respond_to(:validates_as_postcode)

      expect(subject).to receive(:validates_with)
        .with(ActiveModel::Validations::PostcodeValidator, attributes: [:zipcode], country: 'US')
      subject.validates :zipcode, postcode: { country: 'US' }
    end

    it 'checks that all arguments are presents' do
      expect { subject.validates_as_postcode :zipcode }.to raise_error(ArgumentError, ':country must be supplied')
    end

    it 'does not validates arguments when set' do
      expect { subject.validates_as_postcode :zipcode, country: 'ZZ' }.to_not raise_error
    end
  end

  context 'on instance level' do
    let(:countries) { load_data('validator')['countries'] }

    context 'on validations' do
      describe 'with a static :country value' do
        it_should_behave_like 'a correct validator for the given country' do
          let(:zipcodes) { countries['US'] }
          subject { staticaly_validated_instance('StaticTestModel', :US) }
        end
      end

      describe 'with a dynamic :country value' do
        it_should_behave_like 'a correct validator for the given country' do
          let(:zipcodes) { countries['US'] }
          subject { dynamicaly_validated_instance('DynamicTestModel', :US) }
        end

        describe 'that is not a country' do
          let(:zipcodes) { countries[countries.keys.sample] }
          subject { staticaly_validated_instance('NoCountryTestModel', :ZZ) }

          it 'should skip validation' do
            (zipcodes['valids'] + zipcodes['invalids']).shuffle.each do |postcode|
              subject.zipcode = postcode
              expect(subject.valid?).to be_truthy
            end
          end
        end
      end

      describe 'when used to validates postcodes for a country without postcodes' do
        it_should_behave_like 'a correct validator for the given country' do
          let(:zipcodes) { countries['PA'] }
          subject { staticaly_validated_instance('NoPostcodeTestModel', :PA) }
        end
      end
    end

    context 'on errors' do
      subject { staticaly_validated_instance('LocalizedTestModel', :CA) }

      it 'should return a localized error message' do
        %i[fr en].each do |locale|
          I18n.locale = locale
          subject.zipcode = 'INVALID'
          subject.valid?
          expect(subject.errors[:zipcode]).to eq([I18n.t('errors.messages.invalid_postcode')])
        end
      end
    end
  end
end
