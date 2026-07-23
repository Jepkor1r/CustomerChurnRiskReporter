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

import argparse
import os
import random
from datetime import datetime, timedelta

import psycopg
from dotenv import load_dotenv
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
    user = {
        "full_name": fake.name(),           # Random realistic full name
        "email": fake.unique.email(),        # Random unique email address
        "account_status": "active",          # All generated users start as active
        "last_activity": datetime.now()      # Activity set to current time
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

    # Save the insert to the database permanently
    connection.commit()

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

    # Loop and insert one user at a time until we reach the requested count
    for i in range(args.users):
        user = generate_user()
        insert_user(connection, user)

    print(f"\n✓ Successfully inserted {args.users} users!")

    # Always close the connection when done to free up database resources
    connection.close()

    print("✓ Connection closed.")


# Only run main() when this file is executed directly
# Prevents main() from running if this file is imported by another script
if __name__ == "__main__":
    main()
