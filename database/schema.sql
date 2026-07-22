-- Enable pgcrypto so PostgreSQL can generate UUIDs automatically
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Main users table
-- Stores every SaaS user and tracks when they last used the product
CREATE TABLE IF NOT EXISTS users (

    -- Unique identifier for each user, auto-generated (no need to pass it in)
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- User's full name, required, max 100 characters
    full_name VARCHAR(100) NOT NULL,

    -- User's email address, must be unique across all accounts
    email VARCHAR(255) UNIQUE NOT NULL,

    -- Timestamp of the user's most recent activity within the application.
    -- Lambda queries this column to find users inactive for more than 7 days
    -- Nullable because a brand new user may not have any activity yet
    last_activity TIMESTAMPTZ,

    -- Current state of the account
    -- CHECK constraint enforces only these 3 values are allowed at the database level
    account_status VARCHAR(20) 
        NOT NULL 
        DEFAULT 'active' 
        CHECK (account_status IN ('active', 'suspended', 'cancelled')),

    -- Timestamp of when the user account was created, auto-set on insert
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index on last_activity so the churn query runs fast
-- Without this, PostgreSQL would scan every row in the table on every daily run
CREATE INDEX IF NOT EXISTS idx_users_last_activity ON users(last_activity);
