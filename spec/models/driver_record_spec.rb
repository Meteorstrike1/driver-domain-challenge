require 'rails_helper'

RSpec.describe DriverRecord, type: :model do
  subject { described_class }

  let(:valid_record) { { first_names: 'Test', last_name: 'Case', date_of_birth: Date.new(2001, 1, 2), driving_licence_type: 'Full' } }
  let(:valid_licence_number) { 'CASE0102TEXM' }

  describe '#record_match?' do
    it 'matches the record' do
      driver_record = subject.create!(valid_record)
      data_provided = {
        first_names: 'Test',
        last_name: 'Case',
        date_of_birth: Date.new(2001, 1, 2).strftime('%Y-%m-%d'),
      }
      expect(driver_record.record_match?(data_provided)).to eq(true)
    end

    it 'does not match the record' do
      driver_record = subject.create!(valid_record)
      data_provided = {
        first_names: 'Nest',
        last_name: 'Case',
        date_of_birth: Date.new(2001, 1, 2).strftime('%Y-%m-%d'),
      }
      expect(driver_record.record_match?(data_provided)).to eq(false)
    end
  end

  describe '#save_with_retry' do
    it 'will save a valid record where licence number is not provided' do
      driver_record = subject.new(valid_record)
      expect { driver_record.save_with_retry(false) }.to_not raise_error
    end

    it 'will save a valid record where licence number is provided' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_number = valid_licence_number
      expect { driver_record.save_with_retry(true) }.to_not raise_error
    end
  end

  context 'first names' do
    it 'generates a valid record when contains only alphabetic characters' do
      driver_record = subject.new(valid_record)
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when includes hyphen, space, or apostrophe' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = "Je'un Guan-Yip"
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when it is only one alphabetic character' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = 'a'
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when includes only one alphabetic character' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = '                               l'
      expect(driver_record.valid?).to eq(true)
    end

    it 'fails to generate a valid record when it is longer than 32 characters' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = 'really very quite long first name'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when does not contain any alphabetic characters' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = '  -'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when it contains non valid characters' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = 'Jéäô'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when it is nil' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = nil
      expect(driver_record.valid?).to eq(false)
    end

    it 'raises an error when an invalid record is committed to the database' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_number = valid_licence_number
      driver_record.first_names = 'B0b'
      expect { driver_record.save! }.to raise_error(ActiveRecord::RecordInvalid).with_message('Validation failed: First names is invalid')
    end
  end

  context 'last name' do
    it 'generates a valid record when contains only alphabetic characters' do
      driver_record = subject.new(valid_record)
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when includes hyphen, space, or apostrophe' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = "O'Riley Yuan-Foo"
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when it is only one alphabetic character' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = 'a'
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when includes only one alphabetic character' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = '                               l'
      expect(driver_record.valid?).to eq(true)
    end

    it 'fails to generate a valid record when it is longer than 32 characters' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = 'really quite quite long last name'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when does not contain any alphabetic characters' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = '  -'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when it contains non valid characters' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = 'Mäô'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when it is nil' do
      driver_record = subject.new(valid_record)
      driver_record.last_name = nil
      expect(driver_record.valid?).to eq(false)
    end

    it 'raises an error when an invalid record is committed to the database' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_number = valid_licence_number
      driver_record.last_name = '^&7342a'
      expect { driver_record.save! }.to raise_error(ActiveRecord::RecordInvalid).with_message('Validation failed: Last name is invalid')
    end
  end

  context 'driving licence number' do
    it 'generates a valid record without a driving licence number provided' do
      driver_record = subject.new(valid_record)
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record with a valid driving licence number provided' do
      valid_with_licence = valid_record.merge(driving_licence_number: valid_licence_number)
      driver_record = subject.new(valid_with_licence)
      expect(driver_record.valid?).to eq(true)
    end

    it 'fails to generate a valid record with an invalid driving licence number provided' do
      valid_with_licence = valid_record.merge(driving_licence_number: 'CASE0102TEX')
      driver_record = subject.new(valid_with_licence)
      expect(driver_record.valid?).to eq(false)
    end

    it 'raises an error if record with same number already exists' do
      subject.create!(valid_record.merge(driving_licence_number: valid_licence_number))
      driver_record_with_same_licence = subject.new(valid_record.merge(driving_licence_number: valid_licence_number))
      expect(driver_record_with_same_licence.valid?).to eq(false)
      expect { driver_record_with_same_licence.save! }.to raise_error(ActiveRecord::RecordInvalid).with_message('Validation failed: Driving licence number has already been taken')
    end
  end

  context 'date of birth' do
    it 'generates a valid record when person is between 17 and 100 years old' do
      driver_record = subject.new(valid_record)
      years = (17..100).to_a.sample
      driver_record.date_of_birth = Time.zone.today.years_ago(years)
      expect(driver_record.valid?).to eq(true)
    end

    it 'fails to generates a valid record when person is less than 17 years old' do
      driver_record = subject.new(valid_record)
      tomorrow = Time.zone.today + 1
      driver_record.date_of_birth = tomorrow.years_ago(17)
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generates a valid record when person is 101 or older' do
      driver_record = subject.new(valid_record)
      driver_record.date_of_birth = Time.zone.today.years_ago(101)
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generate a valid record when it is nil' do
      driver_record = subject.new(valid_record)
      driver_record.date_of_birth = nil
      expect(driver_record.valid?).to eq(false)
    end

    it 'raises an error when date is less than 17 years ago' do
      driver_record = subject.new(valid_record)
      tomorrow = Time.zone.today + 1
      driver_record.date_of_birth = tomorrow.years_ago(17)
      expect { driver_record.save! }.to raise_error(ActiveRecord::RecordInvalid).with_message('Validation failed: Date of birth is invalid')
    end

    it 'raises an error when date is 101 years ago or more' do
      driver_record = subject.new(valid_record)
      driver_record.date_of_birth = Time.zone.today.years_ago(101)
      expect { driver_record.save! }.to raise_error(ActiveRecord::RecordInvalid).with_message('Validation failed: Date of birth is invalid')
    end

    it 'raises an error when the date is invalid' do
      driver_record = subject.new(valid_record)
      expect { driver_record.date_of_birth = Date.new(1989, 4, 31) }.to raise_error(Date::Error)
    end
  end

  context 'driving licence type' do
    it 'generates a valid record when it is set as Full' do
      driver_record = subject.new(valid_record)
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record when it is set as Provisional' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_type = 'Provisional'
      expect(driver_record.valid?).to eq(true)
    end

    it 'is case insensitive' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_type = 'proVisIOnAl'
      expect(driver_record.valid?).to eq(true)
    end

    it 'fails to generates a valid record when it is not a valid type' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_type = 'Learner'
      expect(driver_record.valid?).to eq(false)
    end

    it 'fails to generates a valid record when it is nil' do
      driver_record = subject.new(valid_record)
      driver_record.driving_licence_type = nil
      expect(driver_record.valid?).to eq(false)
    end
  end

  context 'driving licence number generation' do
    it "generates a valid number when none is provided using person's data" do
      driver_record = subject.create!(valid_record)
      expect(driver_record.driving_licence_number).to match(DriverRecord::LICENCE_REGEX)
      expect(driver_record.driving_licence_number).to start_with('CASE0102TE')
    end

    it "uses first four characters from last name and pads with 'X' if there are less" do
      driver_record = subject.new(valid_record)
      driver_record.last_name = 'A'
      driver_record.save!
      expect(driver_record.driving_licence_number).to start_with('AXXX')
    end

    it "uses first two characters from first names and pads with 'X' if there are less" do
      driver_record = subject.new(valid_record)
      driver_record.first_names = 'A'
      driver_record.save!
      expect(driver_record.driving_licence_number[8..9]).to eq('AX')
    end

    it 'ignores hyphens, spaces, and apostrophes for the name components' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = "- ' ' ' ' ' ' - - - G' e -o rge"
      driver_record.last_name = "- ' ' ' ' ' - - - T - a ' y lor"
      driver_record.save!
      expect(driver_record.driving_licence_number).to start_with('TAYL')
      expect(driver_record.driving_licence_number[8..9]).to eq('GE')
    end

    it 'adds a leading zero to a 1 digit month and day' do
      driver_record = subject.new(valid_record)
      driver_record.date_of_birth = Date.new(2001, 7, 3)
      driver_record.save!
      expect(driver_record.driving_licence_number[4..5]).to eq('07')
      expect(driver_record.driving_licence_number[6..7]).to eq('03')
    end

    it 'uses both digits of a 2 digit month and day' do
      driver_record = subject.new(valid_record)
      driver_record.date_of_birth = Date.new(2001, 11, 28)
      driver_record.save!
      expect(driver_record.driving_licence_number[4..5]).to eq('11')
      expect(driver_record.driving_licence_number[6..7]).to eq('28')
    end

    it 'will retry if the generated licence number is already taken' do
      subject.create!(valid_record.merge(driving_licence_number: valid_licence_number))
      driver_record = subject.new(valid_record)
      allow(driver_record).to receive(:generate_licence_number).and_return('CASE0102TEXM')
      expect { driver_record.save! }.to raise_error(ActiveRecord::RecordInvalid).with_message('Validation failed: Driving licence number has already been taken')
      expect(driver_record).to have_received(:generate_licence_number).exactly(4).times
    end
  end
end
