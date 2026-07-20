# Customer Churn Risk Reporter

A production-style AWS serverless application that automatically identifies inactive SaaS users, generates a professional HTML churn risk report, and emails the Customer Success team every day.

---

## Business Problem

Customer Success teams often spend time manually querying databases to identify users who have become inactive. This manual process is repetitive, time-consuming, and delays customer outreach.

This project automates the entire workflow by identifying users who have not logged in for more than seven days and delivering a daily HTML report to the Customer Success team, enabling proactive customer engagement and improving customer retention.

---

## Solution Overview

Every day at **08:00 UTC**, the system:

1. Triggers automatically using Amazon EventBridge Scheduler.
2. Retrieves database credentials securely from AWS Secrets Manager.
3. Connects to Amazon RDS PostgreSQL.
4. Queries users who have been inactive for more than seven days.
5. Generates a professional HTML churn risk report.
6. Sends the report via Amazon Simple Email Service (SES).
7. Records logs and execution metrics in Amazon CloudWatch.

No manual intervention is required.

---

## Business WorkFlow

```
EventBridge

↓

Lambda starts

↓

Lambda requests credentials from Secrets Manager

↓

Secrets Manager returns credentials

↓

Lambda connects to PostgreSQL

↓

Lambda executes SQL

↓

Lambda generates HTML

↓

Lambda sends email through SES

↓

CloudWatch receives logs

```

---

## AWS Services

- AWS Lambda
- Amazon EventBridge Scheduler
- Amazon RDS PostgreSQL
- Amazon SES
- AWS Secrets Manager
- Amazon CloudWatch
- Amazon VPC
- AWS IAM
- Terraform


---

## Repository Structure

customer-churn-risk-reporter/
│
├── .github/
│   └── workflows/
│       ├── lint.yml
│       ├── python-tests.yml
│       └── terraform.yml
│
├── architecture/
│   ├── aws-architecture.drawio
│   ├── aws-architecture.png
│   ├── business-workflow.png
│   └── sequence-diagram.png
│
├── assets/
│   ├── banner.png
│   └── logo.png
│
├── database/
│   ├── README.md
│   ├── sample_queries.sql
│   ├── schema.sql
│   └── seed.sql
│
├── docs/
│   ├── api-reference.md
│   ├── cost-analysis.md
│   ├── deployment-guide.md
│   ├── design-decisions.md
│   ├── future-enhancements.md
│   ├── security.md
│   └── troubleshooting.md
│
├── lambda/
│   ├── templates/
│   │   ├── churn_report.html
│   │   └── failure_notification.html
│   ├── tests/
│   │   ├── test_database.py
│   │   ├── test_email.py
│   │   ├── test_handler.py
│   │   └── test_report.py
│   ├── __init__.py
│   ├── config.py
│   ├── database.py
│   ├── email.py
│   ├── exceptions.py
│   ├── handler.py
│   ├── html_report.py
│   ├── logger.py
│   ├── requirements.txt
│   └── utils.py
│
├── reports/
│   ├── sample-report.html
│   └── sample-report.pdf
│
├── screenshots/
│   ├── aws-console/
│   │   ├── cloudwatch.png
│   │   ├── eventbridge.png
│   │   ├── lambda.png
│   │   ├── rds.png
│   │   ├── secrets-manager.png
│   │   └── ses.png
│   ├── architecture.png
│   ├── cloudwatch-logs.png
│   ├── cost-explorer.png
│   ├── email-report.png
│   └── terraform-apply.png
│
├── scripts/
│   ├── deploy.sh
│   ├── destroy.sh
│   ├── package_lambda.sh
│   └── seed_database.py
│
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   └── production/
│   ├── modules/
│   │   ├── cloudwatch/
│   │   ├── eventbridge/
│   │   ├── iam/
│   │   ├── lambda/
│   │   ├── networking/
│   │   ├── rds/
│   │   ├── secrets-manager/
│   │   └── ses/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── versions.tf
│
├── .editorconfig
├── .env.example
├── .gitignore
├── .pre-commit-config.yaml
├── CHANGELOG.md
├── LICENSE
├── Makefile
├── README.md
└── requirements.txt

---

## License

This project is licensed under the MIT License.