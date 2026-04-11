require 'swagger_helper'

RSpec.describe 'driver_records', type: :request do
  let(:example_record) { DriverRecord.create!(first_names: 'Test', last_name: 'Case', date_of_birth: Date.new(2001, 10, 12), driving_licence_type: 'full') }

  path '/driver-records' do
    get 'Retrieves all driver records' do
      tags 'Driver Records'
      produces 'application/json'
      response '200', 'driver records found' do
        example 'application/json', :example, [
          {
            first_names: 'Test',
            last_name: 'Case',
            date_of_birth: Date.new(2001, 01, 02),
            driving_licence_number: 'CASE0102TEXM',
            driving_licence_type: 'full'
          }
        ]
        run_test!
      end
    end
  end

  path '/driver-records/{driving_licence_number}' do
    get 'Retrieves a driver record' do
      tags 'Driver Records'
      produces 'application/json'
      parameter name: 'driving_licence_number', in: :path, type: :string

      response '200', 'driver record found' do
        schema type: :object,
               properties: {
                 first_names: { type: :string },
                 last_name: { type: :string },
                 date_of_birth: { type: :string, format: :date },
                 driving_licence_number: { type: :string },
                 driving_licence_type: { type: :string },
               },
               required: %w[first_names last_name date_of_birth driving_licence_type]
        example 'application/json', :example, {
          first_names: 'Test',
          last_name: 'Case',
          date_of_birth: Date.new(2001, 01, 02),
          driving_licence_number: 'CASE0102TEXM',
          driving_licence_type: 'full'
        }
        let(:driving_licence_number) { example_record.driving_licence_number }
        run_test!
      end

      response '404', 'driver record not found' do
        let(:driving_licence_number) { 'invalid' }
        run_test!
      end
    end
  end
end

# TODO: Update for other endpoints
# request_body_example value: { first_names: 'First names', last_name: 'Last name', date_of_birth: Date.new(2001, 10, 12), driving_licence_number: 'CASE0102TEXM', driving_licence_type: 'full' }, name: 'basic', summary: 'Request example'