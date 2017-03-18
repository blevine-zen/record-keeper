require_relative 'spec_helper'

# Ensure that these tests run no matter where user triggers tests from.
# This is important because of the path to the test data files
Dir.chdir(File.dirname(__FILE__))

describe RecordCollection do
  before :each do
    # Overwrite old test data
    File.new("#{Dir.pwd}/data/output.txt", 'w')
    @collection = RecordCollection.new
  end

  describe '#initialize' do
    @collection = RecordCollection.new
    it 'should create a record collection with no records if input is empty' do
      expect(@collection).to be_an_instance_of RecordCollection
      expect(@collection.records.length).to eql 0
    end

    it 'should create a record collection with records if a file is given' do
      @collection = RecordCollection.new('csv_input.csv')
      expect(@collection).to be_an_instance_of RecordCollection
      expect(@collection.records.length).to eql 3
    end
  end

  describe '#read_file' do
    it 'should accurately create records from a csv file' do
      @collection = RecordCollection.new('csv_input.csv')
      expect(@collection.records.length).to eql 3
      record = @collection.records[0]
      expect(record).to be_an_instance_of Record
      expect(record.first_name).to eql 'Matt'
      expect(record.last_name).to eql 'Bellamy'
      expect(record.favorite_color).to eql 'Red'
      expect(record.date_of_birth).to eql Date.new(1978, 6, 9)
    end

    it 'should accurately create records from a psv file' do
      @collection = RecordCollection.new('pipe_input.txt')
      expect(@collection.records.length).to eql 3
      record = @collection.records[0]
      expect(record).to be_an_instance_of Record
      expect(record.first_name).to eql 'Matt'
      expect(record.last_name).to eql 'Bellamy'
      expect(record.favorite_color).to eql 'Red'
      expect(record.date_of_birth).to eql Date.new(1978, 6, 9)
    end
  end

  describe '#add_record' do
    it 'should add a record if a record instance is passed' do
      @collection = RecordCollection.new
      record = Record.new('Hoppus', 'Mark', 'Green', '1972-3-15')
      @collection.add_record(record)
      expect(@collection.records.length).to eql 1
      expect(@collection.records[0].first_name).to eql 'Mark'
    end

    it 'should add a record if a valid csv line is passed' do
      @collection = RecordCollection.new
      line = 'Hoppus, Mark, Green, 1972-3-15'
      @collection.add_record(line)
      expect(@collection.records.length).to eql 1
      expect(@collection.records[0].first_name).to eql 'Mark'
    end

    it 'should add a record if a valid psv line is passed' do
      @collection = RecordCollection.new
      line = 'Hoppus | Mark | Green | 1972-3-15'
      @collection.add_record(line)
      expect(@collection.records.length).to eql 1
      expect(@collection.records[0].first_name).to eql 'Mark'
    end

    it 'should not create a new record if an invalid line is passed' do
      @collection = RecordCollection.new
      line = 'This is a bad argument'
      @collection.add_record(line)
      line = 'Hoppus Mark Green 1972-3-15'
      @collection.add_record(line)
      expect(@collection.records.length).to eql 0
    end
  end

  describe '#sort_by_dob' do
    it 'should sort records by date of birth ascending' do
      @collection = RecordCollection.new('csv_input.csv')
      @collection.sort_by_dob
      records = @collection.records
      expect(records[0].date_of_birth).to be <= records[1].date_of_birth
      expect(records[1].date_of_birth).to be <= records[2].date_of_birth
    end
  end

  describe '#sort_by_color' do
    it 'should sort records by favorite color and then last name ascending' do
      @collection = RecordCollection.new('csv_input.csv')

      # Add another record with a duplicate value for favorite color to test
      # that the function also sorts by last name
      @collection.add_record(Record.new('DeLonge', 'Tom', 'Red', '1975-12-13'))
      @collection.sort_by_color
      records = @collection.records
      expect(records[0].favorite_color).to be == records[1].favorite_color
      expect(records[0].last_name).to be <= records[1].last_name
      expect(records[1].favorite_color).to be >= records[2].favorite_color
      expect(records[2].favorite_color).to be >= records[3].favorite_color
    end
  end

  describe '#sort_by_last_name' do
    it 'should sort records by last name descending' do
      @collection = RecordCollection.new('csv_input.csv')
      @collection.sort_by_last_name
      records = @collection.records
      expect(records[0].last_name).to be >= records[1].last_name
      expect(records[1].last_name).to be >= records[2].last_name
    end
  end

  describe '#save' do
    it 'should save records to the same text file the collection was created from' do
      @collection = RecordCollection.new('data/output.txt')
      initial_number_of_records = @collection.records.length
      @collection.add_record(Record.new('DeLonge', 'Tom', 'Red', '1975-12-13'))
      @collection.add_record(Record.new('Hoppus', 'Mark', 'Green', '1972-3-15'))
      @collection.save

      new_collection = RecordCollection.new('data/output.txt')
      final_number_of_records = new_collection.records.length
      expect(final_number_of_records - initial_number_of_records).to eql 2
    end

    it 'should create a new file and output data there if starting from scratch' do
      @collection = RecordCollection.new
      initial_number_of_records = @collection.records.length
      @collection.add_record(Record.new('DeLonge', 'Tom', 'Red', '1975-12-13'))
      @collection.add_record(Record.new('Hoppus', 'Mark', 'Green', '1972-3-15'))
      @collection.save

      new_collection = RecordCollection.new('data/output.txt')
      final_number_of_records = new_collection.records.length
      expect(initial_number_of_records).to eql 0
      expect(final_number_of_records - initial_number_of_records).to eql 2
    end
  end

  describe '#display_records' do
    it 'should return records in the desired order' do
      @collection = RecordCollection.new('csv_input.csv')
      comparison_collection = RecordCollection.new
      @collection.records.each do |record|
        comparison_collection.records.push(record)
      end
      no_sorting = @collection.display_records
      expect(no_sorting).to eql([MATT_HASH, DOMINIC_HASH, CHRIS_HASH])

      bad_keyword = @collection.display_records('bad keyword')
      expect(bad_keyword).to eql [MATT_HASH, DOMINIC_HASH, CHRIS_HASH]

      by_last_name = @collection.display_records('last name')
      expect(by_last_name).to eql [CHRIS_HASH, DOMINIC_HASH, MATT_HASH]

      by_color = @collection.display_records('color')
      expect(by_color).to eql [MATT_HASH, CHRIS_HASH, DOMINIC_HASH]

      by_dob = @collection.display_records('date of birth')
      expect(by_dob).to eql [DOMINIC_HASH, MATT_HASH, CHRIS_HASH]
    end
  end
end
