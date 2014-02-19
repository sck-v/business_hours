module BusinessHours
  class Week
    def initialize(time_zone = UTC_TIME_ZONE)
      @time_zone = time_zone
      @days = Array.new(7).each_with_index.map { |n, i| Day.new(i) }
    end

    def day(day_name, &block)
      Time.use_zone(@time_zone) do
        day_index = if day_name.is_a? Fixnum
                      day_name
                    elsif day_name.respond_to? :to_s
                      Date::ABBR_DAYNAMES.index(day_name.to_s.capitalize)
                    end
        @days[day_index].tap { |day| day.build(&block) }
      end
    end

    def closed?
      current_day = @days[Date.today.wday]

      return true if current_day.nil? or current_day.closed?  # if there is no data for current day, assume that it's closed all day

      current_time = Time.zone.now
      current_day.closed_at?(current_time)
    end

    def now_open?
      !closed?
    end

    def days
      @days
    end
  end
end