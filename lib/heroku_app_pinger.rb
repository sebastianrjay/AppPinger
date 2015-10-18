require 'rest-client'
require_relative 'errors'

class HerokuAppPinger
  def initialize(urls, daily_start_time, daily_end_time = nil)
    @sleeping = false
    set_and_validate_urls(urls)
    set_and_validate_times(daily_start_time, daily_end_time)
  end

  def active?
    t = Time.now.getutc
    if @start_hour < @end_hour
      t.hour.between?(@start_hour + 1, @end_hour - 1) ||
        (t.hour == @end_hour && t.min < @end_min) ||
          (t.hour == @start_hour && t.min > @start_min)
    elsif @start_hour == @end_hour
       t.min > @start_min && t.min < @end_min
    else
      t.hour.between?(@start_hour + 1, @end_hour + 24 - 1) ||
        (t.hour == @end_hour && t.min < @end_min) ||
          (t.hour == @start_hour && t.min > @start_min)
    end
  end

  def run
    # When inactive, checks whether or not to resume pinging every 60 seconds.
    # When active, makes a GET request to all URLs every 10-20 min.
    while true
      if active?
        @sleeping = false
        @urls.each do |url|
          begin
            response = RestClient.get(url)
            puts "Successfully pinged #{url} at #{Time.now}\n" if response
          rescue => e
            puts("Error raised when attempting to ping URL #{url} at time" +
              "#{Time.now}. The RestClient error was:\n")
            p(e)
            puts
          end
        end

        seconds = 540 + (Random.rand * 600).to_i
        sleep(seconds)
      else
        unless @sleeping
          puts "Entering sleep mode at #{Time.now} for the following URLs:"
          @urls.each { |url| puts url }
          @sleeping = true
        end

        sleep(60)
      end
    end
  end

  private

    def set_and_validate_times(daily_start_time, daily_end_time)
      e = InvalidStartTimeError.new("Start and end times must each be an integer
        hour, or a string in the form 'hh:mm'. The start time and end time (if
        given) must specify a time period no longer than 17 hours and 28
        minutes, since free Heroku apps are forced into recharge/sleep mode
        after more than 18 hours of activity within a 24 hour window. Heroku
        defines an app as active if it has responded to a request within the
        last 30 minutes.")

      start_hour, start_min = parse_and_validate_time(daily_start_time, e)
      if daily_end_time
        end_hour, end_min = parse_and_validate_time(daily_end_time, e)
      else
        end_hour, end_min = (start_hour + 17) % 24, (start_min + 28) % 60
        end_hour += 1 if (start_min + 28) / 60 == 1
      end

      interval_len = ((end_hour - start_hour).abs * 100) + end_min - start_min
      raise e unless interval_len.between?(0, 1728)

      @start_hour, @start_min = start_hour, start_min
      @end_hour, @end_min = end_hour, end_min
    end

    def set_and_validate_urls(urls)
      e = InvalidURLError.new("HerokuAppPinger must receive a single URL string,
            or an array of URL string(s)")
      if urls.is_a? String
        @urls = [urls]
      elsif urls.is_a? Array
        raise e unless urls.all? {|url| url.is_a? String }
        @urls = urls
      else
        raise e
      end
    end

    def parse_and_validate_time(time, e)
      if time.is_a? String
        raise e unless time =~ /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/
        hour, min = time.split(':').map(&:to_i)
      elsif time.is_a? Fixnum
        hour, min = time, 0
        raise e unless hour.between?(0, 23)
      else
        raise e
      end

      [hour, min]
    end
end
