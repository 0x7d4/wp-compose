#!/bin/bash

# Function to prompt for variable value and update .env file
ask_value() {
    read -p "Enter $1: " value
    echo "$1=$value" >> .env
}

# Function to replace domain names in nginx.conf based on .env values
replace_domains() {
    sed -i "s/yourdomain.com/$WORDPRESS_DOMAIN/g" nginx.conf
    sed -i "s/www.yourdomain.com/www.$WORDPRESS_DOMAIN/g" nginx.conf
}

# Check if .env file exists
if [ -f .env ]; then
    echo ".env file already exists."
    read -p "Do you want to change its values? (y/n): " response
    if [ "$response" = "y" ]; then
        rm .env
        echo "Previous .env file removed."
    else
        echo "Exiting without changes to .env file."
        exit 0
    fi
fi

# Ask for each variable's value and update .env file
ask_value "WORDPRESS_DOMAIN"
ask_value "WORDPRESS_DB_NAME"
ask_value "WORDPRESS_DB_USER"
ask_value "WORDPRESS_DB_PASSWORD"
ask_value "WORDPRESS_DB_ROOT_PASSWORD"
ask_value "CERTBOT_EMAIL"

echo "Values have been written to .env file."

# Replace domain names in nginx.conf
replace_domains

echo "Domain names in nginx.conf have been updated."
