require 'test/unit'
require 'business_hours'
require 'timecop'

class TestBusinessHours < Test::Unit::TestCase
  def initialize(*args)
    super
    Time.zone = 'Etc/UTC'
  end

  def test_initialization
    week = BusinessHours::Week.new

    week.day('mon') do
      open_at '10:00'
      close_at '20:00'
      has_break '13:00', '13:30'
    end

    week.day('tue') do
      closed!
    end

    assert_not_nil week
  end

  def test_closed_today
    hours = BusinessHours::Week.new
    hours.day(Date.today.wday) do
      closed!
    end

    assert_equal hours.closed?, true
  end

  def test_open_today
    hours = BusinessHours::Week.new

    hours.day(Date.today.wday) do
      open_at '10:00'
      close_at '20:00'
    end

    Timecop.travel(Time.zone.now.change(hour: 11)) { assert_equal hours.closed?, false }
    Timecop.travel(Time.zone.now.change(hour: 9)) { assert_equal hours.closed?, true }
  end

  def test_different_timezone
    Time.zone = 'Europe/Moscow'
    hours = BusinessHours::Week.new('Europe/Berlin')
    hours.day(Date.today.wday) do
      open_at '10:00'
      close_at '20:00'
    end

    Timecop.travel(Time.zone.now.change(hour: 11)) { assert_equal hours.closed?, true }
    Timecop.travel(Time.zone.now.change(hour: 9)) { assert_equal hours.closed?, true }
    Timecop.travel(Time.zone.now.change(hour: 14)) { assert_equal hours.closed?, false }
    Timecop.travel(Time.zone.now.change(hour: 15)) { assert_equal hours.closed?, false }
    Timecop.travel(Time.zone.now.change(hour: 23)) { assert_equal hours.closed?, true }
  end

  def test_with_breaks
    hours = BusinessHours::Week.new('Europe/Berlin')
    day = hours.day(Date.today.wday) do
      open_at '10:00'
      close_at '20:00'
      has_break '13:30', '14:00'
    end

    assert_equal day.has_breaks?, true
    Timecop.travel(Time.now.change(hour: 13, minutes: 40)) { assert_equal hours.closed?, true }
  end

  def test_initialization_with_dayname
    hours = BusinessHours::Week.new('Europe/Berlin')
    day = hours.day(Date::ABBR_DAYNAMES[Date.today.wday]) do
      open_at '10:00'
      close_at '20:00'
    end

    assert_equal day.today?, true
  end

  def test_default_values
  end

  def test_with_a_next_day
    hours = BusinessHours::Week.new
    hours.day(Date::ABBR_DAYNAMES[Date.today.wday]) do
      open_at '20:00'
      close_at '01:00'
    end

    Timecop.travel(Time.zone.now.change(hour: 21, minutes: 00, day: Date.today.day)) { assert_equal hours.closed?, false }
  end

  def test_with_a_next_day_at_a_month_last_day
    Timecop.freeze(Date.new(2014, 3, 31)) do
      hours = BusinessHours::Week.new
      hours.day(Date::ABBR_DAYNAMES[Date.today.wday]) do
        open_at '20:00'
        close_at '01:00'
      end

      Timecop.travel(Time.zone.now.change(hour: 21, minutes: 00, day: Date.today.day)) { assert_equal hours.closed?, false }
    end
  end
end