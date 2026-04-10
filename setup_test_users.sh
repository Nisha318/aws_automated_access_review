#!/bin/bash
# setup_test_users.sh
# Creates fictitious IAM test users to generate meaningful
# findings for the AWS Automated Access Review project.
# Run cleanup_test_users.sh when done.

set -e

echo "Creating test IAM users..."

# 1. dev-alice — access key, no MFA
aws iam create-user --user-name dev-alice
aws iam create-access-key --user-name dev-alice
echo "  [+] dev-alice created"

# 2. contractor-bob — AdministratorAccess, no MFA (high severity)
aws iam create-user --user-name contractor-bob
aws iam attach-user-policy \
  --user-name contractor-bob \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
echo "  [+] contractor-bob created"

# 3. analyst-carol — ReadOnly, no MFA (control: should be clean)
aws iam create-user --user-name analyst-carol
aws iam attach-user-policy \
  --user-name analyst-carol \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess
echo "  [+] analyst-carol created"

# 4. svc-legacy-etl — inactive ghost account, no MFA
aws iam create-user --user-name svc-legacy-etl
echo "  [+] svc-legacy-etl created"

# 5. svc-data-pipeline — access key + AdministratorAccess (high severity)
aws iam create-user --user-name svc-data-pipeline
aws iam create-access-key --user-name svc-data-pipeline
aws iam attach-user-policy \
  --user-name svc-data-pipeline \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
echo "  [+] svc-data-pipeline created"

echo ""
echo "Done. 5 test users created."
echo "Run ./cleanup_test_users.sh to remove them when finished."