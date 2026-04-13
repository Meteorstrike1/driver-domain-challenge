# Driver Domain
This is a prototype for a driver domain service built using Ruby on Rails. It includes endpoints for create, read, update, and delete.

## Installation and run
1. Install gems
```bash
bundle install
```

2. Set up database
```bash
rails db:migrate
```

3. Seed with example data
```bash
rails db:seed
```

4. Start the application
```bash
./bin/dev
```

Alternatively the app can be run with docker
```bash
docker compose up --build
```

The app will be running on http://localhost:3000

## Exploring the endpoints
Once the app is running the endpoints can be tried either through the Swagger UI or through Bruno.

### Swagger
Navigate to http://localhost:3000/api-docs/index.html to open the Swagger UI, where you can view the documentation and interact with the API endpoints.

### Bruno
If you have [Bruno](https://www.usebruno.com/downloads) installed, open the `bruno` collection folder to try out pre-configured requests for each endpoint.

## Useful commands
Reset database back to example data
```bash
rails db:reset
```

Update swagger docs
```bash
rake rswag:specs:swaggerize
```

## Useful resources
- [Rswag](https://github.com/rswag/rswag)
- [Swagger docs](https://swagger.io/docs/specification/v3_0/about/)