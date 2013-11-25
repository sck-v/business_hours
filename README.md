# BusinessHours

This gem provides simple DSL to describe working hours for business place.

## Installation

Add this line to your application's Gemfile:

    gem 'business_hours'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install business_hours

## Usage

Create new business week for particular time zone:

    business_hours = BusinessHours::Week.new('Europe/Moscow')

Then add some working days:

    business_hours.day(1) do
        open_at '10:00'
        close_at '20:00'
        has_break '13:00', '14:00'
    end

or you can use abbreviation for day name:

    business_hours.day(:mon)

If there is no information about a day, then we assume that it's closed. Or you can mark day as closed with:

    business_hours.day(1) do
        closed!
    end

Then you can easily check if business place is opened now:

    business_hours.now_open?

See test folder for more information

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
