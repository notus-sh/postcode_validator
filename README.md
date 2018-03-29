# PostcodeValidator

[![Build Status](https://travis-ci.org/notus-sh/postcode_validator.svg?branch=master)](https://travis-ci.org/notus-sh/postcode_validator)
[![Gem Version](https://badge.fury.io/rb/postcode_validator.svg)](https://badge.fury.io/rb/postcode_validator)

A simple postcode validator based on the Unicode CLDR project, with an optional integration with ActiveModel.

## Installation

`PostcodeValidator` is distributed as a gem and available on [rubygems.org](https://rubygems.org/gems/postcode_validator) so you can add it to your `Gemfile` or install it manually with:

```ruby
gem install postcode_validator
```

## Usage

You can use `PostcodeValidator` either as a stand-alone validator or integrated with ActiveModel.

### Stand-alone

```ruby
require 'postcode_validator'

validator = PostcodeValidator.new

validator.valid?('98025', country: 'FR') # True
validator.valid?('AB21 9BG', country: :GB) # True
validator.valid?('AB21 9BG', country: :DE) # False
validator.valid?('', country: 'PA') # True - Panama does not use postcodes.
```

The `:country` option is **required**. It can be anything that respond to `to_s`.
If the supplied `:country` is not a valid [ISO-3166 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), a `PostcodeValidator::Error` will be raised.

### ActiveModel integration

```ruby
class Address < ActiveRecord::Base

  # With a dedicated helper
  validates_as_postcode :zipcode, country: :US

  # Or through the generic `validates` class method, mixed with other validators
  validates :post_code,
    presence: true,
    postcode: { allow_nil: true, country: -> { |record| record.country_code } }
end
```

The ActiveModel validator supports the same common arguments others standard validators do (`:if`, `:unless`, `:on`, `:allow_nil`, `:allow_blank` and `:strict`).
The `:country` argument is **required**. It can be either a static value (anything that respond to `to_s`) or a lambda. The lambda will be called with the will be validated record as its first argument.

If the supplied `:country` is not a valid [ISO-3166 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), the postcode validation will be skipped (It's your responsability to validate the value of `:country`).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/notus-sh/postcode_validator.
