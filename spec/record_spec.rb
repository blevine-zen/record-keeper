describe Record do
  before :each do
    @record = Record.new(
      'Last Name',
      'First Name',
      'Color',
      '2000-1-20'
    )
  end

  describe '#initialize' do
    it 'creates a Record object from 4 parameters' do
      expect(@record).to be_an_instance_of Record
    end
  end

  describe '#last_name' do
    it 'should be able to access the value for last name' do
      expect(@record.last_name).to eql 'Last Name'
    end

    it 'should be able to update the value for last name' do
      @record.last_name = 'New Last Name'
      expect(@record.last_name).to eql 'New Last Name'
    end
  end

  describe '#first_name' do
    it 'should be able to access the value for first name' do
      expect(@record.first_name).to eql 'First Name'
    end

    it 'should be able to update the value for first name' do
      @record.first_name = 'New First Name'
      expect(@record.first_name).to eql 'New First Name'
    end
  end

  describe '#favorite_color' do
    it 'should be able to access the value for favorite color' do
      expect(@record.favorite_color).to eql 'Color'
    end

    it 'should be able to update the value for favorite color' do
      @record.favorite_color = 'New Color'
      expect(@record.favorite_color).to eql 'New Color'
    end
  end

  describe '#date_of_birth' do
    it 'should be able to access the value for date of birth' do
      expect(@record.date_of_birth).to eql Date.new(2000, 1, 20)
    end

    it 'should be able to update the value for date of birth' do
      @record.date_of_birth=('1999-2-4')
      expect(@record.date_of_birth).to eql Date.new(1999, 2, 4)
    end
  end

  describe '#display_record' do
    it 'should return the object as a hash' do
      expect(@record.display_record).to eql(
        last_name: 'Last Name',
        first_name: 'First Name',
        favorite_color: 'Color',
        date_of_birth: '2000-01-20'
      )
    end
  end

  describe '#output_to_file' do
    it 'should print each record out as a comma separated value' do
      expect(@record.output_to_file).to eql(
        'Last Name, First Name, Color, 2000-01-20'
      )
    end
  end
end
