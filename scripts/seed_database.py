#!/usr/bin/env python3

"""
=========================================================
Customer Churn Risk Reporter

Automatic Database Seeder

Purpose:
Generate realistic SaaS customer data for development,
testing, and demonstrations.

Usage:
python scripts/seed_database.py --users 100
=========================================================
"""

# argparse lets us accept arguments from the command line (e.g. --users 100)
import argparse

# os lets us read environment variables like DB_HOST, DB_USER, etc.
import os

# random lets us randomly assign account statuses and activity dates
import random

# datetime gives us the current time, timedelta lets us subtract days from it
from datetime import datetime, timedelta,  UTC

# psycopg is the library that connects Python to PostgreSQL
import psycopg

# load_dotenv reads the .env file and makes its values available via os.getenv()
from dotenv import load_dotenv

# Faker generates realistic fake names and email addresses
from faker import Faker

# Load environment variables from the .env file
# This is how the script gets the database credentials without hardcoding them
load_dotenv()

# Create a Faker instance that generates realistic fake names and emails
fake = Faker()

def parse_arguments():
    """
    Parse command-line arguments.
    """

    # Set up the argument parser with a short description
    parser = argparse.ArgumentParser(
        description="Generate sample customer data."
    )

    # --users lets you control how many users to generate when running the script
    # Example: python scripts/seed_database.py --users 50
    # If you don't pass --users, it defaults to 100
    parser.add_argument(
        "--users",
        type=int,
        default=100,
        help="Number of users to generate (default: 100)"
    )

    return parser.parse_args()

def connect_database():
    """
    Establish a connection to PostgreSQL.
    """

    # Connect to the database using credentials loaded from the .env file
    # All values come from environment variables, never hardcoded
    connection = psycopg.connect(
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
    )

    return connection

def generate_user():
    """
    Generate a realistic SaaS customer.
    """

    # Build a single user dictionary with fake but realistic data
    # last_activity is set to right now, meaning this user is currently active

    # Randomly pick an account status using weighted probabilities
    # 85% of users will be active, 10% suspended, 5% cancelled
    # This reflects a realistic distribution in a real SaaS product
    status = random.choices(
        population=["active", "suspended", "cancelled"],
        weights=[85, 10, 5],
        k=1
    )[0]

    # Pick a random number of days ago between 0 and 90
    # This is used below if the user has activity
    days_ago = random.randint(0, 90)

    # Randomly decide if this user has any activity at all
    # 90% chance they have activity, 10% chance they have never logged in (NULL)
    has_activity = random.choices(
        population=[True, False],
        weights=[90, 10],
        k=1
    )[0]

    # If the user has activity, calculate a random past date as their last login
    # If not, set last_activity to None (they signed up but never logged in)
    if has_activity:
        days_ago = random.randint(0, 90)
        last_activity = datetime.now( UTC) - timedelta(days=days_ago)
    else:
        last_activity = None

    user = {
        "full_name": fake.name(),           # Random realistic full name
        "email": fake.unique.email(),        # Random unique email address
        "account_status": status,            # Randomly assigned status
        "last_activity":  last_activity      # Random past date or None
    }

    return user

def insert_user(connection, user):
    """
    Insert a generated user into PostgreSQL.
    """

    # Open a cursor to run the SQL INSERT statement
    with connection.cursor() as cursor:

        # Insert the user's data into the users table
        # %s are placeholders — psycopg replaces them safely to prevent SQL injection
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

def main():
    # Read the --users argument from the command line
    args = parse_arguments()

    # Print a header so the terminal output is easy to read
    print("=" * 50)
    print("Customer Churn Risk Reporter")
    print("Automatic Database Seeder")
    print("=" * 50)

    print(f"Generating {args.users} users...")

    # Connect to the database
    connection = connect_database()

    print("✓ Connected to PostgreSQL!")

    try:
        # Loop and generate one user at a time, inserting each into the database
        for i in range(args.users):
            user = generate_user()
            insert_user(connection, user)

        # Save all inserts to the database in one go after the loop finishes
        # If anything fails above, this line is never reached and nothing is saved
        connection.commit()

        print(f"\n✓ Successfully inserted {args.users} users!")

    except Exception as error:
        # If anything goes wrong, undo all inserts so the database stays clean
        connection.rollback()
        print(f"\n❌ Database Error: {error}")

    finally:
        # Always close the connection whether the inserts succeeded or failed
        # This frees up the database connection regardless of what happened
        connection.close()
        print("✓ Connection closed.")


# Only run main() when this file is executed directly
# Prevents main() from running if this file is imported by another script
if __name__ == "__main__":
    main()
