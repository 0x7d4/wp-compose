#!/bin/bash

# Function to replace domain names in nginx.conf based on environment variables
replace_domains() {
    sed -i "s/yourdomain.com/$WORDPRESS_DOMAIN/g" nginx.conf
    sed -i "s/www.yourdomain.com/www.$WORDPRESS_DOMAIN/g" nginx.conf
}

# Function to prompt for variable value and export them
ask_value() {
    read -p "Enter $1: " value
    export "$1=$value"
}

# Function to set all variables
set_all() {
    ask_value "WORDPRESS_DOMAIN"
    ask_value "WORDPRESS_DB_NAME"
    ask_value "WORDPRESS_DB_USER"
    ask_value "WORDPRESS_DB_PASSWORD"
    ask_value "WORDPRESS_DB_ROOT_PASSWORD"
    ask_value "CERTBOT_EMAIL"
}

# Check if environment variables are set
if [ -z "$WORDPRESS_DOMAIN" ]; then
    set_all
    echo "Environment variables have been set."
else
    echo "Environment variables already exist."
    read -p "Do you want to change their values? (y/n): " response
    if [ "$response" = "y" ]; then
        set_all
        echo "Environment variables have been updated."
    else
        echo "Using existing environment variables."
    fi
fi

# Replace domain names in nginx.conf
replace_domains

echo "Domain names in nginx.conf have been updated."
