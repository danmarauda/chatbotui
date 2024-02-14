#!/bin/bash
set +x

# Step 0: Replace placeholders in the SQL file
# Path to the original SQL file
SQL_FILE="supabase/migrations/20240108234540_setup.sql"

# Temporary file for storing the modified SQL file
TEMP_FILE="temp.sql"

# Environment variables (these should be set in your Railway environment or .env file)
PROJECT_URL=${NEXT_PUBLIC_SUPABASE_URL:-http://localhost:8000}
SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY:-your_default_service_role_key}

# Replace placeholders in the SQL file without logging sensitive information
sed "s|PROJECT_URL_PLACEHOLDER|$PROJECT_URL|g; s|SERVICE_ROLE_KEY_PLACEHOLDER|$SERVICE_ROLE_KEY|g" $SQL_FILE > $TEMP_FILE > /dev/null 2>&1

# Overwrite the original SQL file with the modified version
mv $TEMP_FILE $SQL_FILE

echo "Placeholders replaced in the SQL file."

# Step 1: Link to the Supabase project
echo "Linking to Supabase project..."
npx supabase link --project-ref $SUPABASE_REFERENCE_ID > /dev/null 2>&1

# Check if linking was successful
if [ $? -ne 0 ]; then
    echo "Failed to link to Supabase project."
    exit 1
fi

# Step 2: Push the database changes
# URL-encode the password using Node.js to avoid logging sensitive information
ENCODED_PASSWORD=$(node -e "console.log(encodeURIComponent(process.argv[1]))" "$SUPABASE_DATABASE_PASSWORD")

# Replace [YOUR-PASSWORD] in SUPABASE_DATABASE_URL with the actual password
SUPABASE_DATABASE_URL_WITH_PASSWORD=${SUPABASE_DATABASE_URL/\[YOUR-PASSWORD\]/$ENCODED_PASSWORD}

echo "Pushing database changes to Supabase..."
npx supabase db push --db-url "$SUPABASE_DATABASE_URL_WITH_PASSWORD" > /dev/null 2>&1

# Check if db push was successful
if [ $? -ne 0 ]; then
    echo "Failed to push database changes to Supabase."
fi

echo "Supabase operations completed successfully."
