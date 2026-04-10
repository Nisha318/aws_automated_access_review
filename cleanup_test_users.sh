#!/bin/bash
# cleanup_test_users.sh
# Removes all test IAM users and their associated resources
# created by setup_test_users.sh.

set -e

USERS=("dev-alice" "contractor-bob" "analyst-carol" "svc-legacy-etl" "svc-data-pipeline")

echo "Cleaning up test IAM users..."

for USER in "${USERS[@]}"; do
  echo "  Removing $USER..."

  # Detach all managed policies
  POLICIES=$(aws iam list-attached-user-policies \
    --user-name "$USER" \
    --query 'AttachedPolicies[].PolicyArn' \
    --output text 2>/dev/null || echo "")

  for POLICY in $POLICIES; do
    aws iam detach-user-policy \
      --user-name "$USER" \
      --policy-arn "$POLICY"
    echo "    Detached policy: $POLICY"
  done

  # Delete all access keys
  KEYS=$(aws iam list-access-keys \
    --user-name "$USER" \
    --query 'AccessKeyMetadata[].AccessKeyId' \
    --output text 2>/dev/null || echo "")

  for KEY in $KEYS; do
    aws iam delete-access-key \
      --user-name "$USER" \
      --access-key-id "$KEY"
    echo "    Deleted access key: $KEY"
  done

  # Delete login profile if it exists
  aws iam delete-login-profile \
    --user-name "$USER" 2>/dev/null || true

  # Delete the user
  aws iam delete-user --user-name "$USER"
  echo "    [x] $USER deleted"
done

echo ""
echo "Done. All test users removed."