require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1',
      },
      paths: {},
      components: {
        schemas: {
          driver_record: {
            type: 'object',
            properties: {
              driving_licence_number: { type: 'string' },
              first_names: { type: 'string' },
              last_name: { type: 'string' },
              date_of_birth: { type: 'string', format: 'date' },
              driving_licence_type: { type: 'string' },
            },
            required: %w[first_names last_name date_of_birth driving_licence_type],
          },
        },
      },
      servers: [
        {
          url: 'http://localhost:3000',
        },
      ],
    },
  }
  config.openapi_format = :yaml
end
