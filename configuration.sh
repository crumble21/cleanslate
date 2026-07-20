#!/bin/bash

# Prompt for ports with defaults
read -p "Enter AUTHENTICATION_SERVER_PORT [3001]: " AUTH_PORT
AUTH_PORT=${AUTH_PORT:-3001}

read -p "Enter CLIENT_PORT [3000]: " CLIENT_PORT
CLIENT_PORT=${CLIENT_PORT:-3000}

read -p "Enter HASURA_PORT [8080]: " HASURA_PORT
HASURA_PORT=${HASURA_PORT:-8080}

read -p "Enter DOCKER_HOST_IP [127.0.0.1]: " DOCKER_HOST_IP
DOCKER_HOST_IP=${DOCKER_HOST_IP:-127.0.0.1}

# Prompt for the domain without default, required input
read -p "Enter the DOMAIN of your instance. Do not include the https://: " DOMAIN
if [ -z "$DOMAIN" ]; then
  echo "Error: DOMAIN is required."
  exit 1
fi

# Prompt for the external PostgreSQL connection string, required input.
# This instance uses an existing PostgreSQL server rather than a bundled container.
# Example: postgres://cleanslate:PASSWORD@100.107.217.126:5432/cleanslate
read -rp "Enter HASURA_GRAPHQL_DATABASE_URL: " DATABASE_URL
if [ -z "$DATABASE_URL" ]; then
  echo "Error: HASURA_GRAPHQL_DATABASE_URL is required."
  exit 1
fi

# Generate UUIDs
JWT_SECRET=$(uuidgen)
HASURA_ADMIN_SECRET=$(uuidgen)

# Write to .env file
cat <<EOF > .env
AUTHENTICATION_SERVER_PORT=$AUTH_PORT
CLIENT_PORT=$CLIENT_PORT
DOCKER_HOST_IP=$DOCKER_HOST_IP
DOMAIN=$DOMAIN
HASURA_GRAPHQL_ADMIN_SECRET=$HASURA_ADMIN_SECRET
HASURA_GRAPHQL_DATABASE_URL=$DATABASE_URL
HASURA_GRAPHQL_JWT_SECRET='{"type":"HS256","key":"$JWT_SECRET"}'
HASURA_PORT=$HASURA_PORT
JWT_SIGNING_SECRET=$JWT_SECRET
EOF

echo ".env file generated!"
