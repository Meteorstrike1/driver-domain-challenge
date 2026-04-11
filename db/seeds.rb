# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

DriverRecord.create!(driving_licence_number: 'JONE0804BOBD', first_names: 'Bob', last_name: 'Jones', date_of_birth: Date.new(2001, 8, 4), driving_licence_type: 'Full')
DriverRecord.create!(driving_licence_number: 'CASE0507TEAA', first_names: 'Tench', last_name: 'Casey', date_of_birth: Date.new(1995, 05, 07),  driving_licence_type: 'Provisional')
DriverRecord.create!(driving_licence_number: 'MORR0229HEOW', first_names: 'Helen', last_name: 'Morris', date_of_birth: Date.new(2000, 2, 29), driving_licence_type: 'Full')
DriverRecord.create!(driving_licence_number: 'PARK0404DASK', first_names: 'David', last_name: 'Parker', date_of_birth: Date.new(2005, 4, 4), driving_licence_type: 'Provisional')
DriverRecord.create!(driving_licence_number: 'YULO0919JEDA', first_names: 'Jessica', last_name: 'Yulon', date_of_birth: Date.new(1994, 9, 19), driving_licence_type: 'Full')
DriverRecord.create!(first_names: 'Martha', last_name: 'Jones', date_of_birth: Date.new(1926, 04, 11), driving_licence_type: 'Full')
DriverRecord.create!(first_names: 'A', last_name: 'Williams', date_of_birth: Date.new(1979, 11, 12), driving_licence_type: 'Full')
DriverRecord.create!(first_names: 'Jay', last_name: 'Holland', date_of_birth: Date.new(2009, 3, 31), driving_licence_type: 'Provisional')
DriverRecord.create!(first_names: 'Jamie', last_name: 'Holland', date_of_birth: Date.new(2009, 3, 31), driving_licence_type: 'Provisional')
DriverRecord.create!(first_names: 'Jack', last_name: 'Holland', date_of_birth: Date.new(2009, 3, 31), driving_licence_type: 'Provisional')
DriverRecord.create!(first_names: 'Matt-Tom Finn', last_name: "O'Riley", date_of_birth: Date.new(1991, 05, 07), driving_licence_type: 'Provisional')
DriverRecord.create!(first_names: 'Lilly', last_name: 'Lee', date_of_birth: Date.new(1987, 12, 31), driving_licence_type: 'Full')
DriverRecord.create!(first_names: "Je'von", last_name: 'Evans', date_of_birth: Date.new(1967, 7, 7), driving_licence_type: 'Full')
