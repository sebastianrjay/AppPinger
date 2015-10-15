require_relative 'errors'

class HerokuAppPinger
  def initialize(urls, daily_start_time, daily_end_time)
    set_and_validate_urls(urls)
    set_and_validate_times(daily_start_time, daily_end_time)
  end

  def active?
    t = Time.now
    t.hour.between?(@start_hour + 1, @end_hour - 1) ||
      ((t.hour == @end_hour && t.min < @end_min) ||
        (t.hour == @start_hour && t.min > @start_min))
  end

  def run
    # When inactive, checks whether or not to resume pinging every 60 seconds.
    # When active, makes a GET request to all URLs every 10-20 min.
    while true
      if active?
        @urls.each do |url|
          begin
            RestClient.get(url)
          rescue => e
            puts "Error raised when attempting to ping URL #{url} at time
              #{Time.now}. The RestClient error was:\n\n"
            p(e)
            puts
          end
        end

        seconds = 540 + (Random.rand * 600).to_i
        sleep(seconds)
      end

      sleep(60)
    end
  end

  private

    def set_and_validate_times(daily_start_time, daily_end_time)
      e = InvalidStartTimeError.new("Times must be an integer hour or a string
        in the form 'hh:mm'. The start and end time must specify a time period
        no longer than 17 hours, 28 minutes, since free Heroku apps are forced
        into recharge/sleep mode after more than 18 hours of activity within
        a 24 hour window. Heroku defines an app as active if it has responded to
        a request within the last 30 minutes.")

      unless [daily_start_time, daily_end_time].all? { |t| t.is_a?(Fixnum) || t.is_a?(String) }
        raise e
      end

      start_hour, start_min = daily_start_time.split(':').map { |str| str.to_i }
      end_hour, end_min = daily_end_time.split(':').map { |str| str.to_i }
      raise e unless [start_min, end_min].all? { |min| min.between?(0, 59) }

      interval_len = ((end_hour - start_hour).abs * 100) + end_min - start_min
      raise e unless interval_len.between?(0, 1728)

      @start_hour, @start_min = start_hour, start_min
      @end_hour, @end_min = end_hour, end_min
    end

    def set_and_validate_urls(urls)
      e = InvalidURLError.new("HerokuAppPinger must receive a single URL string,
            or an array of URL strings")
      if urls.is_a? String
        @urls = [urls]
      elsif urls.is_a? Array
        raise e unless urls.all? {|url| url.is_a? String }
        @urls = urls
      else
        raise e
      end
    end
end
