#!/bin/bash

# Path to the original SQL file
SQL_FILE="supabase/migrations/20240108234540_setup.sql"

# Temporary file for storing the modified SQL file
TEMP_FILE="temp.sql"

# Environment variables (these should be set in your Railway environment or .env file)
PROJECT_URL=${NEXT_PUBLIC_SUPABASE_URL:-http://localhost:8000}
SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY:-your_default_service_role_key}

# Replace placeholders in the SQL file
sed "s|PROJECT_URL_PLACEHOLDER|$PROJECT_URL|g; s|SERVICE_ROLE_KEY_PLACEHOLDER|$SERVICE_ROLE_KEY|g" $SQL_FILE > $TEMP_FILE

# Overwrite the original SQL file with the modified version
mv $TEMP_FILE $SQL_FILE

echo "Placeholders replaced in $SQL_FILE"
