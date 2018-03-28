# frozen_string_literal: true

shared_examples 'a correct validator for the given country' do
  it 'that accept valid postcodes' do
    zipcodes['valids'].shuffle.each do |postcode|
      subject.zipcode = postcode
      expect(subject.valid?).to be_truthy
    end
  end

  it 'that reject invalid postcodes' do
    zipcodes['invalids'].shuffle.each do |postcode|
      subject.zipcode = postcode
      expect(subject.valid?).to be_falsey
    end
  end
end

describe ActiveModel::Validations::PostcodeValidator do
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

  context 'on validations' do
    let(:countries) { load_data('validator')['countries'] }

    describe 'whith a static :country value' do
      it_should_behave_like 'a correct validator for the given country' do
        let(:zipcodes) { countries['US'] }
        subject do
          StaticTestModel ||= Class.new(TestModel) do
            validates_as_postcode :zipcode, country: 'US'
          end
          StaticTestModel.new
        end
      end
    end

    describe 'whith a dynamic :country value' do
      it_should_behave_like 'a correct validator for the given country' do
        let(:zipcodes) { countries['US'] }
        subject do
          DynamicTestModel ||= Class.new(TestModel) do
            validates_as_postcode :zipcode, country: ->(instance) { instance.country }
          end
          DynamicTestModel.new(country: 'US')
        end
      end

      describe 'that is not a country' do
        let(:zipcodes) { countries[countries.keys.sample] }
        subject do
          NoCountryTestModel ||= Class.new(TestModel) do
            validates_as_postcode :zipcode, country: ->(instance) { instance.country }
          end
          NoCountryTestModel.new(country: 'ZZ')
        end

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
        subject do
          NoPostcodeTestModel ||= Class.new(TestModel) do
            validates_as_postcode :zipcode, country: 'PA'
          end
          NoPostcodeTestModel.new
        end
      end
    end
  end
end
