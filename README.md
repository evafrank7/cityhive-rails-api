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
