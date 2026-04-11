class DriverRecord < ApplicationRecord
  before_validation :set_licence_number, on: :create
  before_validation :preprocess_attributes

  NAME_REGEX = /\A(?=.*[A-Za-z])[A-Za-z\- ']{1,32}\z/
  LICENCE_REGEX = /\A[A-Z]{4}\d{4}[A-Z]{4}\z/

  validates :first_names, length: { minimum: 1, maximum: 32 }, presence: true, format: { with: NAME_REGEX, message: :invalid }
  validates :last_name, length: { minimum: 1, maximum: 32 }, presence: true, format: { with: NAME_REGEX, message: :invalid }
  validates :driving_licence_number, uniqueness: true, format: { with: LICENCE_REGEX, message: :invalid }
  validates :date_of_birth, presence: true
  validate :date_of_birth_in_range
  validates :driving_licence_type, presence: true, inclusion: { in: %w[Full Provisional] }

  def preprocess_attributes
    self.driving_licence_number.presence&.upcase!
    self.driving_licence_type.presence&.capitalize!
  end

  # Show only the fields of interest
  def as_json(options = {})
    super(options.merge(except: %i[id created_at updated_at]))
  end

  # Tries to save to database and retries licence generation if there were conflicts
  def save_with_retry(licence_provided)
    retries = 0
    begin
      save!
    rescue ActiveRecord::RecordNotUnique => e
      retries += 1
      if !licence_provided && retries < 3
        self.driving_licence_number = nil
        retry
      end
      Rails.logger.info { "Attempt #{retries} failed to generate unique driving licence number" }
      raise e
    end
  end

  def record_match?(data_provided)
    data_provided[:first_names] == self.first_names &&
    data_provided[:last_name] == self.last_name &&
    data_provided[:date_of_birth] == self.date_of_birth.strftime('%Y-%m-%d')
  end

private

  def set_licence_number
    self.driving_licence_number ||= generate_licence_number
  end

  def date_of_birth_in_range
    return if self.date_of_birth.blank?

    today = Date.today
    dob = self.date_of_birth

    had_birthday = today.month > dob.month || (today.month >= dob.month && today.day > dob.day)
    age = had_birthday ? today.year - dob.year : today.year - dob.year  - 1
    if age < 17 || age > 100
      errors.add(:date_of_birth, message: :invalid)
    end
  end

  def generate_licence_number
    return if self.date_of_birth.blank?

    last_name_chars = extract_letters(self.last_name, 4)
    month = self.date_of_birth.strftime('%m')
    day = self.date_of_birth.strftime('%d')
    first_names_chars = extract_letters(self.first_names, 2)
    random_letters = ('A'..'Z').to_a.sample(2).join
    "#{last_name_chars}#{month}#{day}#{first_names_chars}#{random_letters}"
  end

  # Takes required number of first digits from a name, pads if less than required
  def extract_letters(string, digits)
    return unless string.is_a?(String) && digits.is_a?(Integer)

    # This assumes the validation only let alpha characters in otherwise
    letters = string.delete("' -")
    first_chars = letters.chars.first(digits)
    length = first_chars.length
    (digits - first_chars.length).times { first_chars << 'X' } if length < digits
    first_chars.join
  end
end
