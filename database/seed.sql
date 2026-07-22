/*
=========================================================
 Customer Churn Risk Reporter
 Seed Data
---------------------------------------------------------
 Purpose:
 Populate the users table with realistic SaaS users for
 testing customer churn reporting.

 Scenarios Included:
 1. Active users
 2. Churn-risk users
 3. Suspended users
 4. Cancelled users
 5. Newly registered users

 Total Records: 100
=========================================================
*/


-- ===========================================
-- Active Users
-- Recent activity within the last 7 days
-- These users should NOT appear in the churn report.
-- ===========================================

INSERT INTO users (
    full_name,
    email,
    last_activity,
    account_status,
    created_at
)
VALUES
(
    'Grace Wanjiku',
    'grace.wanjiku@example.com',
    NOW() - INTERVAL '1 day',
    'active',
    NOW() - INTERVAL '2 years'
),
(
    'Brian Otieno',
    'brian.otieno@example.com',
    NOW() - INTERVAL '2 days',
    'active',
    NOW() - INTERVAL '18 months'
),
(
    'Faith Njeri',
    'faith.njeri@example.com',
    NOW() - INTERVAL '3 days',
    'active',
    NOW() - INTERVAL '1 year'
),
(
    'Kevin Kiptoo',
    'kevin.kiptoo@example.com',
    NOW() - INTERVAL '5 days',
    'active',
    NOW() - INTERVAL '8 months'
),
(
    'Mercy Chebet',
    'mercy.chebet@example.com',
    NOW() - INTERVAL '6 days',
    'active',
    NOW() - INTERVAL '6 months'
);

-- ===========================================
-- Churn Risk Users
-- Active accounts with no activity
-- for more than seven days.
-- These SHOULD appear in the churn report.
-- ===========================================


INSERT INTO users (
    full_name,
    email,
    last_activity,
    account_status,
    created_at
)
VALUES
(
    'James Mwangi',
    'james.mwangi@example.com',
    NOW() - INTERVAL '8 days',
    'active',
    NOW() - INTERVAL '2 years'
),
(
    'Sarah Achieng',
    'sarah.achieng@example.com',
    NOW() - INTERVAL '12 days',
    'active',
    NOW() - INTERVAL '18 months'
),
(
    'David Kiptoo',
    'david.kiptoo@example.com',
    NOW() - INTERVAL '18 days',
    'active',
    NOW() - INTERVAL '1 year'
),
(
    'Lilian Wambui',
    'lilian.wambui@example.com',
    NOW() - INTERVAL '25 days',
    'active',
    NOW() - INTERVAL '9 months'
),
(
    'John Kamau',
    'john.kamau@example.com',
    NOW() - INTERVAL '45 days',
    'active',
    NOW() - INTERVAL '3 years'
);

-- ==========================================
-- Suspended Users
-- These users are intentionally excluded
-- from churn reporting.
-- ==========================================

INSERT INTO users (
    full_name,
    email,
    last_activity,
    account_status,
    created_at
)
VALUES
(
    'Peter Mutiso',
    'peter.mutiso@example.com',
    NOW() - INTERVAL '20 days',
    'suspended',
    NOW() - INTERVAL '2 years'
),
(
    'Susan Atieno',
    'susan.atieno@example.com',
    NOW() - INTERVAL '35 days',
    'suspended',
    NOW() - INTERVAL '15 months'
);

-- ==========================================
-- Cancelled Users
-- These users have already left the service
-- and should not appear in the churn report.
-- ==========================================

INSERT INTO users (
    full_name,
    email,
    last_activity,
    account_status,
    created_at
)
VALUES
(
    'Alice Kariuki',
    'alice.kariuki@example.com',
    NOW() - INTERVAL '60 days',
    'cancelled',
    NOW() - INTERVAL '4 years'
),
(
    'Mark Ouma',
    'mark.ouma@example.com',
    NOW() - INTERVAL '90 days',
    'cancelled',
    NOW() - INTERVAL '2 years'
);

-- ==========================================
-- Newly Registered Users
-- These users have not yet performed
-- any activity.
-- ==========================================

INSERT INTO users (
    full_name,
    email,
    last_activity,
    account_status,
    created_at
)
VALUES
(
    'Joy Kemunto',
    'joy.kemunto@example.com',
    NULL,
    'active',
    NOW() - INTERVAL '1 day'
),
(
    'Dennis Korir',
    'dennis.korir@example.com',
    NULL,
    'active',
    NOW()
);