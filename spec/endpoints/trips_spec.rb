require 'spec_helper'

describe 'Traxo::Client trips endpoints' do
  let(:client) { Traxo::Client.new('', '', 'TEST_TOKEN') }
  let(:headers) { {'Authorization' => 'Bearer TEST_TOKEN'} }

  describe '#get_trips' do
    let(:call) { client.get_trips(start: nil) }
    let(:address) { "#{Traxo::Client::API_URL}trips"}
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trips.json") }
    let(:stub) do 
      stub_request(:get, address)
      .with(headers: headers)
      .to_return(body: fixture_response)
    end

    let(:options) do
      {
        segments: '1',
        start: 'yesterday',
        since: '2015-05-01',    # Filter results changed since this UTC date/time (ISO8601)
        :until => '2016-12-31', # Filter results changed until this UTC date/time (ISO8601)
        :end => 'tomorrow',
        recursive: '1',
        status: 'all',
        privacy: 'Public',
        purpose: 'Personal',
        offset: 3,
        limit: 4
      }
    end

    it 'makes a GET request to the corrrect address with an access token in the headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'includes a "start=today" parameter by default' do
      default_stub = stub_request(:get, address)
                     .with(headers: headers, query: {start: 'today'})
                     .to_return(body: fixture_response)
      client.get_trips

      expect(default_stub).to have_been_requested
    end

    it 'accepts a variety of parameters' do
      options_stub = stub_request(:get, address)
                     .with(headers: headers, query: options)
                     .to_return(body: fixture_response)
      client.get_trips(options)

      expect(options_stub).to have_been_requested
    end

    it 'returns an array of Traxo::Trip objects' do
      stub
      response = call

      expect(response).to be_instance_of Array
      
      types = response.map(&:class).uniq
      expect(types).to eq [Traxo::Trip]
    end
  end

  describe '#get_trip' do
    let(:call) { client.get_trip(123456) }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) do
      stub_request(:get, "#{Traxo::Client::API_URL}trips/123456")
      .with(headers: headers)
      .to_return(body: fixture_response)
    end
    
    it 'makes a GET request to the correct address (including trip id) with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'accepts a segments parameter' do
      segment_stub = stub_request(:get, "#{Traxo::Client::API_URL}trips/123456")
                     .with(headers: headers, query: {segments: 1})
                     .to_return(body: fixture_response)
      client.get_trip(123456, segments: true)

      expect(segment_stub).to have_been_requested
    end

    it 'returns a Traxo::Trip object if found' do
      stub
      response = call

      expect(response).to be_instance_of Traxo::Trip
    end

    xit 'raises an exception if the trip is not found' do
    end
  end

  describe '#get_current_trip' do
    let(:address) { "#{Traxo::Client::API_URL}trips/current" }
    let(:call) { client.get_current_trip }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'returns a Traxo::Trip object if found' do
      stub
      response = call

      expect(response).to be_instance_of(Traxo::Trip)
    end

    xit 'raises an exception if not found' do
    end
  end

  describe '#get_upcoming_trips' do
    pending
  end

  describe '#get_past_trips' do
    let(:address) { "#{Traxo::Client::API_URL}trips/past" }
    let(:call) { client.get_past_trips }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trips.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'returns an array of Traxo::Trip objects' do
      stub
      results = call
      types = results.map(&:class).uniq

      expect(results).to be_instance_of Array
      expect(types).to match_array [Traxo::Trip]
    end

    it 'accepts some options: segments, privacy, purpose, offset, limit' do
      args = { segments: 1, privacy: 'Buddies Only', purpose: 'Personal', offset: 5, limit: 10 }
      options_stub = stub_request(:get, address).with(headers: headers, query: args)
                                        .to_return(body: fixture_response)
      client.get_past_trips(args)

      expect(options_stub).to have_been_requested      
    end

  end

  describe '#get_trip_oembed' do
    let(:address) { "#{Traxo::Client::API_URL}trips/oembed/123456" }
    let(:call) { client.get_trip_oembed(123456) }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip_oembed.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'returns a Traxo::TripOEmbed object if found' do
      stub
      response = call

      expect(response).to be_instance_of Traxo::TripOEmbed
    end

    xit 'raises an exception if not found' do
    end
  end

end