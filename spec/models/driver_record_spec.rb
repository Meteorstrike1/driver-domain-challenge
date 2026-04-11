require 'rails_helper'

RSpec.describe DriverRecord, type: :model do
  subject { described_class }

  let(:valid_record) do
    {
      first_names: 'Test',
      last_name: 'Case',
      date_of_birth: Date.new(2001, 1, 2),
      driving_licence_type: 'full',
    }
  end
  let(:valid_licence_number) { 'CASE0102TEXM' }

  {
    first_names: ' -',
    last_name: 'aweae',
    date_of_birth: Date.new(2001, 1, 12),
    driving_licence_number: '1221211221',
    driving_licence_type: 'full',
  }

  context 'first names' do
    it 'generates a valid record with a name' do
      driver_record = subject.new(valid_record)
      driver_record.first_names = '  -'
      expect(driver_record.valid?).to eq(false)
    end
  end

  context 'driving licence number' do
    it 'generates a valid record without a driving licence number provided' do
      driver_record = subject.new(valid_record)
      expect(driver_record.valid?).to eq(true)
    end

    it 'generates a valid record with a valid driving licence number provided' do
      valid_with_licence = valid_record.merge({ driving_licence_number: valid_licence_number })
      driver_record = subject.new(valid_with_licence)
      expect(driver_record.valid?).to eq(true)
    end

    it 'fails to generate a valid record with an invalid driving licence number provided' do
      valid_with_licence = valid_record.merge({ driving_licence_number: 'CASE0102TEX' })
      driver_record = subject.new(valid_with_licence)
      expect(driver_record.valid?).to eq(false)
    end
  end

  # TODO: Tests
  # describe '#generate_licence_number' do
  # end
end
