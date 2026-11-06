# CityHive Rails E-Commerce API

A REST API built with Ruby on Rails and MongoDB for browsing products, generating checkout quotes, and completing orders.

This project implements the provided CityHive controllers and adds the supporting application configuration, models, routes, error handling, seed data, integration tests, and TypeScript API verification.

## Tech Stack

- Ruby 3.4.x
- Rails 8.1.x (API-only)
- MongoDB 8.x
- Mongoid 9.1.x
- Docker and Docker Compose
- TypeScript and Node.js

## Getting Started

### Prerequisites

- Docker Desktop with Docker Compose
- Node.js and npm (for the TypeScript verification script)

### Start the Application

Clone the repository and navigate into the project directory.

```bash
docker compose up --build -d
```

The Rails API will be available at:

`http://localhost:3000`

### Seed the Database

Populate MongoDB with sample products:

```bash
docker compose exec web bin/rails runner db/seeds.rb
```

The seed data includes products across multiple categories, with both active and inactive products.

### Stop the Application

```bash
docker compose down
```

## API Endpoints

| Method | Endpoint             | Description                              |
|--------|----------------------|------------------------------------------|
| GET    | `/products`          | List active products                     |
| GET    | `/products/:id`      | Retrieve an active product               |
| POST   | `/checkout/quote`    | Calculate cart subtotal, tax, and total  |
| POST   | `/checkout/complete` | Create an order and update inventory     |

### Product Filtering

The products endpoint supports optional query parameters:

- `category`: Filter by product category.
- `query`: Case-insensitive search by product name.
- `page`: Page number (default: 1).
- `limit`: Products per page (default: 25, maximum: 100).

Example:

```bash
curl "http://localhost:3000/products?category=Clothing&page=1&limit=10"
```

### Checkout Quote

```bash
curl -X POST http://localhost:3000/checkout/quote \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {
        "product_id": "REPLACE_WITH_PRODUCT_ID",
        "quantity": 2
      }
    ]
  }'
```

Returns itemized pricing, subtotal, 8% tax, and total in cents.

### Complete Checkout

```bash
curl -X POST http://localhost:3000/checkout/complete \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "items": [
      {
        "product_id": "REPLACE_WITH_PRODUCT_ID",
        "quantity": 2
      }
    ]
  }'
```

Returns HTTP `201 Created` with an order ID and total.

## Running Tests

Rails integration tests cover product retrieval, filtering, missing-product handling, checkout quotes, invalid carts, and order creation with inventory updates.

```bash
docker compose exec -e RAILS_ENV=test web bin/rails test
```

The test environment uses a separate MongoDB database to avoid modifying development data.

## TypeScript API Verification

Install Node.js dependencies:

```bash
npm install
```

Run API verification while Rails is running:

```bash
npm run verify
```

Check TypeScript types:

```bash
npm run typecheck
```

The verification script exercises the running API, checks response status codes and selected response fields, and returns a nonzero exit status if verification fails.

---

# Original Exercise Instructions
-------------------------------------------------
# Senior Technical Support / SRE Exercise

## Overview

You are provided with two Rails controllers that implement a simple E-commerce API.

Your task is to build a complete, working Rails API application around them.

The controllers should be treated as the primary source of requirements. You are expected to inspect the code, infer the application's needs, and implement the missing pieces required to make the API functional.

This exercise is designed to reflect the type of work commonly encountered in a Senior Technical Support / SRE role, where you are often required to understand unfamiliar code, troubleshoot issues, stand up local environments, validate behavior, and automate verification.

---

## Requirements

Using the provided controllers, build a working Rails API application.

You are responsible for determining and implementing:

* Application structure
* Mongoid configuration
* Routes
* Models
* Any required model fields and types
* Error handling
* Seed data
* Basic integration tests

Use reasonable assumptions where requirements are not explicitly defined.

---

## Technology Requirements

Please use:

- Ruby 3.4.x
- Rails 8.1.x
- MongoDB 8.x
- Mongoid 9.1.x

---

## Environment

The application must run locally using Docker.

Provide everything necessary for a reviewer to start the application and its dependencies.

A reviewer should be able to clone the repository and start the application using a simple command.

Example:

```bash
docker compose up
```

You may choose the exact implementation details.

---

## API Verification Script

Create a TypeScript-based verification script that exercises the running API.

The script should:

- Use TypeScript, not plain JavaScript
- Include whatever supporting files are needed to run it, such as `package.json` and `tsconfig.json`
- Connect to the running Rails application
- Exercise the product and checkout endpoints
- Validate response status codes and response shapes
- Use typed interfaces for expected API responses
- Exit with a non-zero status code if validation fails

The script should be runnable with a documented command, for example:

```bash
npm install
npm run verify
```

---

## Documentation

Provide a README that includes:

* Setup instructions
* How to start the application
* How to run tests
* How to execute the verification script
* Any assumptions you made while implementing the application

A reviewer should be able to follow your instructions without additional guidance.

---

## What We Are Evaluating

We are not looking for a production-ready ecommerce platform.

We are evaluating:

* Ability to understand unfamiliar code
* Ability to infer requirements from existing code
* Rails fundamentals
* Troubleshooting skills
* Automation skills
* General engineering judgment

We value simplicity, clarity, and maintainability over excessive complexity.

---

## Deliverables

Please submit:

* Source code
* Docker configuration
* Automated tests
* TypeScript verification script
* README

---

## Time Expectation

This exercise is intended to take approximately 3-4 hours.

Please prioritize completeness and clarity over perfection.

---

## Follow-Up Interview

During the follow-up interview, we may ask you to:

* Explain your implementation decisions
* Explain your verification script
* Investigate a few bugs and bottlenecks in the application
* Add a small feature or make a small change to the existing functionality
* Discuss how you would improve the application for production use

Good luck!
