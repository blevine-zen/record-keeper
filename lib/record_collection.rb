require 'logger'

require_relative 'record'

# Contains a list of records and provides methods for sorting
class RecordCollection
  attr_reader :records

  def initialize(input = false)
    @file = input
    @records = []
    @logger = Logger.new('record_collection.log')

    return unless @file
    read_file(@file)
  end

  def parse_record_line(line)
    line.split(/,|\|/).map(&:strip)
  end

  def read_file(file)
    File.open(file).each do |line|
      add_record(line)
    end
  end

  def add_record(record)
    # If a record instance is passed to this method, we should just append it
    # to records
    begin
      unless record.class == Record
        split_line = parse_record_line(record)
        record = Record.new(
          split_line[0], # Last name
          split_line[1], # First name
          split_line[2], # Favorite color
          split_line[3]  # Date of Birth
        )
      end
      @records.push(record)
      true

    rescue TypeError
      @logger.error("#{record} is not a valid input format")
      false
    end
  end

  def save
    unless @file
      save_directory = "#{Dir.pwd}/data"
      Dir.mkdir('data') unless File.exist?(save_directory)

      @file = File.new("#{save_directory}/output.txt", 'w')
    end

    File.open(@file, 'w') do |file|
      @records.each do |record|
        file.puts record.output_to_file
      end
    end
  end

  def display_records(sorting = false)
    if sorting
      case sorting
      when 'color'
        sort_by_color
      when 'date of birth'
        sort_by_dob
      when 'last name'
        sort_by_last_name
      end
    end

    @records.map(&:display_record)
  end

  def sort_by_dob
    @records.sort! do |record1, record2|
      record1.date_of_birth <=> record2.date_of_birth
    end
  end

  def sort_by_color
    @records.sort! do |record1, record2|
      [record2.favorite_color, record1.last_name] <=>
        [record1.favorite_color, record2.last_name]
    end
  end

  def sort_by_last_name
    @records.sort! do |record1, record2|
      record2.last_name <=> record1.last_name
    end
  end
end
