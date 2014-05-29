# Boolean DSL

[![Code Climate](https://codeclimate.com/github/jobready/boolean_dsl.png)](https://codeclimate.com/github/jobready/boolean_dsl)
[![Build Status](https://travis-ci.org/jobready/boolean_dsl.svg)](https://travis-ci.org/jobready/boolean_dsl)

Boolean DSL is a simple boolean language for creating business rules

## Installation

Add this line to your application's Gemfile:

    gem 'boolean_dsl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boolean_dsl

## Usage

```ruby
require 'boolean_dsl'

context = {alpha: 1}
script = "(1 < 4 or 5 < 4) and (1 == 1 and alpha == 1)"
BooleanDsl::Evaluator.new(script, context).outcome

```

## Contributing

1. Fork it ( http://github.com/jobready/boolean_dsl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
