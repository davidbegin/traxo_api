module Traxo
  class Client

    def get_trips(options = {})
      data = get_trips_options(options)
      url = "#{ API_URL }trips#{ query_string(data) }"
      response = get_request_with_token(url)
      response.map { |trip_params| Trip.new(trip_params) }
    end

    def get_trip(trip_id, options = {})
      data = get_trip_options(options)
      url = "#{ API_URL }trips/#{ trip_id }#{ query_string(data) }"
      response = get_request_with_token(url)
      Trip.new(response)
    end

    def get_current_trip(options = {})
      data = get_trip_options(options)
      url = "#{ API_URL }trips/current#{ query_string(data) }"
      response = get_request_with_token(url)
      Trip.new(response)
    end

    def get_past_trips(options = {})
      data = get_past_trips_options(options)
      url = "#{ API_URL }trips/past#{ query_string(data) }"
      response = get_request_with_token(url)
      response.map { |trip| Trip.new(trip) }
    end

    def get_trip_oembed(trip_id)
      url = "#{ API_URL }trips/oembed/#{trip_id}"
      response = get_request_with_token(url)
      TripOEmbed.new(response)
    end

      private

    def get_trips_options(args)
      # not implemented: count (via X-Total-Count header)
      # until: Filter results changed until this UTC date/time (ISO8601)
      # since: Filter results changed since this UTC date/time (ISO8601)
      # recursive: Include changed sub-objects (requires: since or until)
      # start: listed as defaulting to "today" on Traxo API Explorer (as of 5/12/15)

      unless args.empty?
        options = [:segments, :start, :end, :since, :until, :status, :privacy,
                   :purpose, :count, :offset, :limit, :recursive]
        args.select! { |a| options.include? a }
        args.delete(:recursive) unless (args[:since] || args[:until])
      end
      args[:segments] = 1 if args[:segments]
      args[:recursive] = 1 if args[:recursive]
      {start: 'today'}.merge(args)
    end

    def get_trip_options(args)
      ([1, true].include? args[:segments]) ? { segments: 1 } : {}
    end

    def get_past_trips_options(args)
      args[:segments] = 1 if [true, 1, '1'].include? args[:segments]
      options = [:segments, :privacy, :purpose, :limit, :offset]
      args.select! { |a| options.include? a }
      args
    end

  end
end