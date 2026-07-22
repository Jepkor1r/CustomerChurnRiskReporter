/*
=========================================================
 Customer Churn Risk Reporter
 Sample Queries
---------------------------------------------------------
 Purpose:
 Verify business logic before integrating AWS Lambda.
=========================================================
*/

-- =====================================================
-- General Database Verification
-- =====================================================

-- Show all users with their key details
-- Use this to confirm data was inserted correctly
SELECT
    full_name,
    email,
    account_status,
    last_activity,
    created_at
FROM users;

-- Count how many users are in the database in total
SELECT COUNT(*) AS total_users
FROM users;

-- =====================================================
-- Customer Activity Queries
-- =====================================================

-- Show only users whose account is currently active
-- and when they last used the product
SELECT
    full_name,
    last_activity
FROM users
WHERE account_status = 'active';

-- =====================================================
-- Customer Churn Detection
-- =====================================================

-- Returns active users who have not engaged with the application
-- for more than seven days.
-- These are the at-risk users that will appear in the daily churn report
-- Sorted oldest activity first so the most at-risk users appear at the top
-- This query represents the core business logic executed
-- by AWS Lambda to generate the daily churn risk report.

SELECT
    full_name,
    email,
    last_activity
FROM users
WHERE account_status = 'active'
  AND last_activity IS NOT NULL
  AND last_activity < NOW() - INTERVAL '7 days'
ORDER BY last_activity ASC;

-- Count how many active users are currently at churn risk
-- Useful for a quick summary number at the top of the report
SELECT COUNT(*) AS total_churn_risk_users
FROM users
WHERE account_status = 'active'
  AND last_activity IS NOT NULL
  AND last_activity < NOW() - INTERVAL '7 days';

-- =====================================================
-- Customer Lifecycle Queries
-- =====================================================

-- Find users who signed up but have never performed
-- any activity within the application.
-- A NULL last_activity indicates no recorded user activity.
SELECT
    full_name,
    created_at
FROM users
WHERE last_activity IS NULL;

-- Find all users whose account has been suspended
SELECT
    full_name,
    account_status
FROM users
WHERE account_status = 'suspended';

-- Find all users whose account has been cancelled
SELECT
    full_name,
    account_status
FROM users
WHERE account_status = 'cancelled';

-- =====================================================
-- Account Status Summary
-- =====================================================

-- Count how many users are in each status group 
-- (active, suspended, cancelled).
-- Gives a quick overview of account status distribution.
SELECT
    account_status,
    COUNT(*) AS total_users
FROM users
GROUP BY account_status
ORDER BY account_status;
