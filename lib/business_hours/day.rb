require 'delegate'

module BusinessHours
  class Day
    class DayDelegator < SimpleDelegator
      def open_at(time)
        self.open_at = Time.zone.parse(time)
      end

      def close_at(time)
        self.close_at = Time.zone.parse(time)
      end

      def has_break(from, to)
        self.break = { from: Time.zone.parse(from), to: Time.zone.parse(to) }
      end

      def closed!
        self.closed = true
      end
    end

    attr_accessor :open_at, :close_at, :closed, :break

    class << self
      def build(&block)
        day = new
        day.build(&block)
        day
      end
    end

    def build(&block)
      delegator = DayDelegator.new(self)
      delegator.instance_eval(&block)
      self
    end

    def initialize(day_of_week)
      @day_of_week = day_of_week

      @open_at = nil
      @close_at = nil
      @closed = false
      @break = { from: nil, to: nil }
    end

    def closed?
      @closed or [@open_at, @close_at].any?(&:nil?)
    end

    def today?
      @day_of_week == Date.today.wday
    end

    def has_breaks?
      @break.values_at(:from, :to).compact.any?
    end

    def closed_at?(time)
      return true if closed?

      open = @open_at.change(day: time.day, month: time.month, year: time.year)
      close = @close_at.change(day: time.day, month: time.month, year: time.year)

      close = close.change(day: close.day + 1) if open > close

      result = !time.between?(open, close)

      if has_breaks?
        break_start = @break[:from].change(day: time.day, month: time.month, year: time.year)
        break_end = @break[:to].change(day: time.day, month: time.month, year: time.year)

        result = result and time.between?(break_start, break_end)
      end

      result
    end

    def to_s(format = :short)
      case format
      when :short
        Date::ABBR_DAYNAMES[@day_of_week]
      else
        Date::DAYNAMES[@day_of_week]
      end  
    end
  end
end