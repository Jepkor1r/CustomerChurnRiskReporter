CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email TEXT UNIQUE NOT NULL,
    last_activity TIMESTAMPTZ,
    account_status VARCHAR(20) CHECK (account_status IN ('active', 'inactive', 'suspended')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_users_last_activity
ON users(last_activity);