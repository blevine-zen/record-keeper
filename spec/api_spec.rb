require_relative 'spec_helper'

# Ensure that these tests run no matter where user triggers tests from.
# This is important because of the path to the test data files
Dir.chdir(File.dirname(__FILE__))

describe RecordDemoAPI::API do
  include Rack::Test::Methods

  def app
    RecordDemoAPI::API
  end

  before :each do
    # Overwrite old test data
    File.new("#{Dir.pwd}/data/output.txt", 'w')
  end

  context 'POST /records' do
    it 'does not allow GET' do
      get '/records'
      expect(last_response.status).to eql 405
    end

    it 'does not allow DELETE' do
      delete '/records'
      expect(last_response.status).to eql 405
    end

    it 'Creates a new record from valid csv input' do
      post(
        '/records',
        { record: 'Bellamy, Matt, Red, 1978-06-09' },
        'Content-Type' => 'application/json'
      )
      expect(last_response.status).to eql 201
      expect(last_response.body).to eql [MATT_HASH].to_json
      output = File.readlines("#{Dir.pwd}/data/output.txt", 'r').grep(/Bellamy/)
      expect(output.size).to be > 0
    end

    it 'Creates a new record from valid pipe input' do
      post(
        '/records',
        { record: 'Bellamy | Matt | Red | 1978-06-09' },
        'Content-Type' => 'application/json'
      )
      expect(last_response.status).to eql 201
      expect(last_response.body).to eql [MATT_HASH].to_json
      output = File.readlines("#{Dir.pwd}/data/output.txt", 'r').grep(/Bellamy/)
      expect(output.size).to be > 0
    end

    it 'Does not create a new record from invalid input' do
      post(
        '/records',
        { record: 'Bellamy Matt Red 1978-06-09' },
        'Content-Type' => 'application/json'
      )
      expect(last_response.status).to eql 400
      output = File.readlines("#{Dir.pwd}/data/output.txt", 'r').grep(/Bellamy/)
      expect(output.size).to eql 0
    end
  end

  context 'GET /records/birthdate' do
    it 'does not allow POST' do
      post '/records/birthdate'
      expect(last_response.status).to eql 405
    end

    it 'does not allow DELETE' do
      delete '/records/birthdate'
      expect(last_response.status).to eql 405
    end

    it 'Returns records sorted by birthdate' do
      get '/records/birthdate'
      expect(last_response.status).to eql 200
      expect(last_response.body).to eql [].to_json

      # Post some records and verify that they are now display_records
      post(
        '/records',
        { record: 'Bellamy | Matt | Red | 1978-06-09' },
        'Content-Type' => 'application/json'
      )
      post(
        '/records',
        { record: 'Wolstenholme | Chris | Green | 1978-12-02' },
        'Content-Type' => 'application/json'
      )
      post(
        '/records',
        { record: 'Howard | Dominic | Blue | 1977-12-07' },
        'Content-Type' => 'application/json'
      )

      get '/records/birthdate'
      expect(last_response.status).to eql 200
      expect(last_response.body).to eql [DOMINIC_HASH, MATT_HASH, CHRIS_HASH].to_json
    end
  end

  context 'GET /records/name' do
    it 'does not allow POST' do
      post '/records/name'
      expect(last_response.status).to eql 405
    end

    it 'does not allow DELETE' do
      delete '/records/name'
      expect(last_response.status).to eql 405
    end

    it 'Returns records sorted by last name' do
      get '/records/name'
      expect(last_response.status).to eql 200
      expect(last_response.body).to eql [].to_json

      # Post some records and verify that they are now display_records
      post(
        '/records',
        { record: 'Bellamy | Matt | Red | 1978-06-09' },
        'Content-Type' => 'application/json'
      )
      post(
        '/records',
        { record: 'Wolstenholme | Chris | Green | 1978-12-02' },
        'Content-Type' => 'application/json'
      )
      post(
        '/records',
        { record: 'Howard | Dominic | Blue | 1977-12-07' },
        'Content-Type' => 'application/json'
      )

      get '/records/name'
      expect(last_response.status).to eql 200
      expect(last_response.body).to eql [CHRIS_HASH, DOMINIC_HASH, MATT_HASH].to_json
    end
  end
end
