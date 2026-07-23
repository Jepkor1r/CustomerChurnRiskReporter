---

# Design Decisions.md

This document should explain **why** you made certain technical choices.

---

# Database Design Decisions

---

## Why PostgreSQL?

PostgreSQL was selected because it is a mature relational database with excellent support for SQL, indexing, constraints and transactional consistency.

It is also fully supported by Amazon RDS, making local development closely match the intended production environment.

## Why UUID Primary Keys?

The application uses UUIDs instead of auto-increment integers.

Reasons:

- Prevents predictable IDs
- Better suited for distributed systems
- Compatible with future microservices
- Supported natively by PostgreSQL through pgcrypto

## Why TIMESTAMPTZ?

User activity timestamps are stored using TIMESTAMPTZ instead of TIMESTAMP.

Reasons:

- Preserves timezone information
- Avoids ambiguity between environments
- Compatible with AWS Lambda and Amazon RDS
- Supports consistent comparisons across regions

## Why CHECK Constraints?

Account status validation is enforced at the database level using a CHECK constraint.

Only the following values are allowed:

- active
- suspended
- cancelled

This prevents invalid data regardless of the application that inserts records.

## Why Index last_activity?

The Lambda function searches for inactive customers every day.

Without an index, PostgreSQL would scan the entire table.

An index allows PostgreSQL to locate inactive users much more efficiently as the dataset grows.

## Why Allow NULL last_activity?

New customers may register but never log into the application.

Allowing NULL values accurately represents this business scenario and enables reporting on inactive new accounts.

## Why Manual Seed Data?

The SQL seed file provides deterministic data.

Benefits:

- Repeatable testing
- Easy demonstrations
- Predictable query results
- Helpful during development

## Why Automatic Seeder?

A Python-based seeder was added to generate larger datasets.

Benefits:

- Performance testing
- Realistic demonstrations
- Flexible dataset sizes
- No need to manually write SQL inserts

## Why Faker?

Faker generates realistic names and email addresses.

Using realistic data makes reports easier to understand while avoiding the use of real customer information.

## Why Environment Variables?

Database credentials are loaded from a .env file using python-dotenv rather than being hardcoded.

Benefits:

- Keeps sensitive information out of source code
- Makes configuration portable across environments
- Simplifies local development
- Aligns with AWS deployment practices

## Why Database Transactions?


The automatic database seeder inserts all generated users within a single database transaction.

The transaction is committed only after every insert succeeds.

If any error occurs, the transaction is rolled back.

Benefits:

- Prevents partially inserted datasets
- Preserves database consistency
- Makes failures easier to recover from
- Reflects production database practices

## Why Modular Programming?

The database seeder follows a modular design by separating responsibilities into individual functions.

Examples include:

- `parse_arguments()`
- `connect_database()`
- `generate_user()`
- `insert_user()`
- `main()`

This approach improves readability, testing, and maintainability by ensuring each function performs a single responsibility.

Benefits:

- Easier debugging
- Better code organization
- Simpler future enhancements
- Functions can be reused in other scripts if needed

## Why Parameterized SQL?

All SQL INSERT statements use parameterized queries instead of string interpolation.

Example:

```python
cursor.execute(
    """
    INSERT INTO users (
        full_name,
        email,
        account_status,
        last_activity
    )
    VALUES (%s, %s, %s, %s)
    """,
    (
        user["full_name"],
        user["email"],
        user["account_status"],
        user["last_activity"],
    ),
)
```

## Why Command-Line Arguments?

The seeder uses Python's argparse module to allow the number of generated users to be specified at runtime.

Example:

python scripts/seed_database.py --users 1000

Benefits:

- Flexible dataset sizes
- No code changes required
- Useful for testing different workloads
- Makes the tool reusable for development and demonstrations