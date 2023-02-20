# frozen_string_literal: true

class TestModel
  include ActiveModel::Model
  attr_accessor :zipcode, :country
end

def staticaly_validated_klass(country)
  Class.new(TestModel) do
    validates_as_postcode :zipcode, country: country
  end
end

def staticaly_validated_instance(class_name, country)
  Kernel.const_set(class_name, staticaly_validated_klass(country)) unless Kernel.const_defined?(class_name)
  klass = Kernel.const_get(class_name)
  klass.new
end

def dynamicaly_validated_klass
  Class.new(TestModel) do
    validates_as_postcode :zipcode, country: ->(instance) { instance.country }
  end
end

def dynamicaly_validated_instance(class_name, country)
  Kernel.const_set(class_name, dynamicaly_validated_klass) unless Kernel.const_defined?(class_name)
  klass = Kernel.const_get(class_name)
  klass.new(country: country)
end

shared_examples 'a correct validator for the given country' do
  it 'that accept valid postcodes' do
    zipcodes['valids'].shuffle.each do |postcode|
      subject.zipcode = postcode
      expect(subject).to be_valid
    end
  end

  it 'that reject invalid postcodes' do
    zipcodes['invalids'].shuffle.each do |postcode|
      subject.zipcode = postcode
      expect(subject).not_to be_valid
    end
  end
end
