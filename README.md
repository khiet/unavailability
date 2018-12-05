![travis ci](https://travis-ci.org/khiet/unavailability.svg?branch=master)

# Unavailability

Unavailability simply adds a capability to manage availabilities.
I extracted this gem from the work I am doing for [ehochef.com](https://ehochef.com) where I have to allow a user to make their day either _available_ or _unavailable_ via a calendar (I use [simple_calendar](https://github.com/excid3/simple_calendar) for UI).

Since we want to keep a user's availability _available_ by default, managing i.e. adding/removing "unavailability" rather than "availability" makes sense to me; hence, the name of the gem and the logic followed in the code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "unavailability"
```

And then execute:

```ruby
bundle install
```

Generate a migration file to create the `unavailable_dates` table:

```ruby
rails generate unavailable_date
```

Run the migration:

```ruby
rails db:migrate
```

Edit a Model as the following:

```ruby
# Since it is a Polymorphic association, it can be added to any number of Models
class User < ApplicationRecord
  include Unavailability
end
```

## Usage

Check if the model is available for a Date:

```ruby
  user.available_for_date?(Date.today)
```

Return all available Users:

```ruby
  User.available_for_date(Date.today)
```

Make a Date range unavailable:

```ruby
  user.make_available(from: Date.parse('2050-01-10'), to: Date.parse('2050-01-15'))
```

Make a Date range available:

```ruby
  user.make_unavailable(from: Date.parse('2050-01-08'), to: Date.parse('2050-01-08'))
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/unavailability. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Unavailability project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/unavailability/blob/master/CODE_OF_CONDUCT.md).

```

```
