require 'date'

# Represents an individual record for a given person
class Record
  attr_accessor :last_name
  attr_accessor :first_name
  attr_accessor :favorite_color

  # Treating date of birth differently since we should do more than merely
  # update the field with a new string
  attr_reader :date_of_birth

  def initialize(last_name, first_name, favorite_color, date_of_birth)
    @last_name = last_name
    @first_name = first_name
    @favorite_color = favorite_color
    @date_of_birth = Date.parse(date_of_birth)
  end

  def date_of_birth=(date)
    @date_of_birth = Date.parse(date)
  end

  def output_to_file
    "#{last_name}, #{first_name}, #{favorite_color}, #{date_of_birth}"
  end

  def display_record
    {
      last_name: @last_name.to_s,
      first_name: @first_name.to_s,
      favorite_color: @favorite_color.to_s,
      date_of_birth: @date_of_birth.to_s
    }
  end
end
