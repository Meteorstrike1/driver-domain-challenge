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
              driving_licence_number: { type: 'string', example: 'JONE1012FRIS' },
              first_names: { type: 'string', minLength: 1, maxLength: 32, example: 'Fred' },
              last_name: { type: 'string', minLength: 1, maxLength: 32, example: 'Jones' },
              date_of_birth: { type: 'string', format: 'date', example: '1999-10-12' },
              driving_licence_type: { type: 'string', enum: %w[Full Provisional] },
            },
            required: %w[first_names last_name date_of_birth driving_licence_type],
          },
          driver_record_without_driving_licence_number: {
            type: 'object',
            properties: {
              first_names: { type: 'string', minLength: 1, maxLength: 32, example: 'Fred' },
              last_name: { type: 'string', minLength: 1, maxLength: 32, example: 'Jones' },
              date_of_birth: { type: 'string', format: 'date', example: '1999-10-12' },
              driving_licence_type: { type: 'string', enum: %w[Full Provisional] },
            },
            required: %w[first_names last_name date_of_birth driving_licence_type],
            additionalProperties: false,
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
