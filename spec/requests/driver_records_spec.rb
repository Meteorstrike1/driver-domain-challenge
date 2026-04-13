require 'swagger_helper'

RSpec.describe 'driver_records', type: :request do
  let(:example_record) { DriverRecord.create!(driving_licence_number: 'CASE0507TEAA', first_names: 'Tench', last_name: 'Casey', date_of_birth: Date.new(1995, 5, 7), driving_licence_type: 'Provisional') }
  let(:example_record_to_delete) { DriverRecord.create!(driving_licence_number: 'PARK0404DASK', first_names: 'David', last_name: 'Parker', date_of_birth: Date.new(2005, 4, 4), driving_licence_type: 'Provisional') }
  let(:example_create) do
    {
      first_names: 'Test',
      last_name: 'Case',
      date_of_birth: Date.new(2001, 1, 2),
      driving_licence_type: 'full',
    }
  end
  let(:example_delete) do
    {
      first_names: 'David',
      last_name: 'Parker',
      date_of_birth: Date.new(2005, 4, 4),
    }
  end

  path '/driver-records' do
    get 'Retrieves all driver records' do
      tags 'Driver Records'
      produces 'application/json'
      response '200', 'driver records found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/driver_record' }
        example 'application/json', :response, [
          {
            driving_licence_number: 'CASE0507TEAA',
            first_names: 'Tench',
            last_name: 'Casey',
            date_of_birth: Date.new(1995, 0o5, 0o7),
            driving_licence_type: 'Provisional',
          },
        ]
        run_test!
      end
    end

    post 'Create a driver record' do
      tags 'Driver Records'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :driver_record, in: :body, schema: {
        oneOf: [
          { '$ref' => '#/components/schemas/driver_record' },
          { '$ref' => '#/components/schemas/driver_record_without_driving_licence_number' },
        ],
      }

      response '201', 'driver record created' do
        schema oneOf: [{ '$ref' => '#/components/schemas/driver_record' }, { '$ref' => '#/components/schemas/driver_record_without_driving_licence_number' }]
        example 'application/json', :with_licence_number, {
          driving_licence_number: 'GILE1012JUXM',
          first_names: 'Julia Suzanne',
          last_name: 'Giles',
          date_of_birth: Date.new(2001, 10, 12),
          driving_licence_type: 'Provisional',
        }
        example 'application/json', :without_licence_number, {
          first_names: 'Julia Suzanne',
          last_name: 'Giles',
          date_of_birth: Date.new(2001, 10, 12),
          driving_licence_type: 'Provisional',
        }
        let(:driver_record) { example_create }
        run_test!
      end

      response '400', 'bad request body' do
        let(:driver_record) { {} }
        run_test!
      end

      response '409', 'driver licence number conflict' do
        before do
          allow_any_instance_of(DriverRecord).to receive(:save!).and_raise(ActiveRecord::RecordNotUnique)
        end
        let(:driver_record) { example_create.merge(driving_licence_number: 'CASE0507TEAA') }
        run_test!
      end

      response '422', 'record invalid' do
        let(:driver_record) { example_create.merge(first_names: '1234') }
        run_test!
      end
    end
  end

  path '/driver-records/{driving_licence_number}' do
    get 'Retrieves a driver record' do
      tags 'Driver Records'
      produces 'application/json'
      parameter name: 'driving_licence_number', in: :path, example: 'CASE0507TEAA', type: :string

      response '200', 'driver record found' do
        schema '$ref' => '#/components/schemas/driver_record'
        example 'application/json', :response, {
          driving_licence_number: 'CASE0507TEAA',
          first_names: 'Tench',
          last_name: 'Casey',
          date_of_birth: Date.new(1995, 0o5, 0o7),
          driving_licence_type: 'Full',
        }
        let(:driving_licence_number) { example_record.driving_licence_number }
        run_test!
      end

      response '404', 'driver record not found' do
        let(:driving_licence_number) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a driver record' do
      tags 'Driver Records'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'driving_licence_number', in: :path, example: 'CASE0507TEAA', type: :string
      parameter name: :driver_record, in: :body, schema: {
        type: :object,
        properties: {
          first_names: { type: :string, example: 'Trent' },
          last_name: { type: :string, example: 'Comet' },
          driving_licence_type: { type: :string, example: 'Full' },
        },
      }

      response '200', 'driver record updated' do
        schema '$ref' => '#/components/schemas/driver_record'
        example 'application/json', :all_possible_fields, {
          first_names: 'Trent',
          last_name: 'Comet',
          driving_licence_type: 'Full',
        }
        example 'application/json', :just_driving_licence_type, {
          driving_licence_type: 'Full',
        }
        example 'application/json', :just_first_names, {
          first_names: 'Trent',
        }
        example 'application/json', :just_last_name, {
          last_name: 'Comet',
        }
        let(:driving_licence_number) { example_record.driving_licence_number }
        let(:driver_record) { example_record }
        run_test!
      end

      response '400', 'parameter missing' do
        let(:driving_licence_number) { example_record.driving_licence_number }
        let(:driver_record) { {} }
        run_test!
      end

      response '404', 'driver record not found' do
        let(:driving_licence_number) { 'NOTFOUND' }
        let(:driver_record) { example_record }
        run_test!
      end

      response '422', 'no permitted fields provided' do
        let(:driving_licence_number) { example_record.driving_licence_number }
        let(:driver_record) { { date_of_birth: Date.new(1995, 5, 7) } }
        run_test!
      end

      response '422', 'invalid data' do
        let(:driving_licence_number) { example_record.driving_licence_number }
        let(:driver_record) { { first_names: '123', last_name: '456', driving_licence_type: 'Learner' } }
        run_test!
      end
    end

    delete 'Deletes a driver record' do
      tags 'Driver Records'
      consumes 'application/json'
      parameter name: 'driving_licence_number', in: :path, example: 'PARK0404DASK', type: :string
      parameter name: :driver_record, in: :body, schema: {
        type: :object,
        properties: {
          first_names: { type: :string, example: 'David' },
          last_name: { type: :string, example: 'Parker' },
          date_of_birth: { type: :string, format: :date, example: '2005-04-04' },
        },
        required: %w[first_names last_name date_of_birth],
      }

      response '204', 'driver record deleted' do
        example 'application/json', :example, {
          first_names: 'David',
          last_name: 'Parker',
          date_of_birth: Date.new(2005, 4, 4),
        }
        let(:driving_licence_number) { example_record_to_delete.driving_licence_number }
        let(:driver_record) { example_delete }
        run_test!
      end

      response '400', 'parameter missing' do
        let(:driving_licence_number) { example_record_to_delete.driving_licence_number }
        let(:driver_record) { nil }
        run_test!
      end

      response '404', 'driver record not found' do
        let(:driving_licence_number) { 'NOTFOUND' }
        let(:driver_record) { example_delete }
        run_test!
      end

      response '409', 'driver record does not match' do
        let(:driving_licence_number) { example_record_to_delete.driving_licence_number }
        let(:driver_record) { example_delete.merge(first_names: 'Paul') }
        run_test!
      end
    end
  end
end
