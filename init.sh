#!/bin/bash

# Function to replace domain names in nginx.conf based on environment variables
nginx_replace_domain() {
    sed -i "s/www.yourdomain.com/www.$1/g" nginx.conf
    sed -i "s/yourdomain.com/$1/g" nginx.conf
    echo "Domain names in nginx.conf have been updated."
}

# Function to prompt for variable value and export them
ask_value() {
    read -p "Enter $1: " value
    export "$1=$value"
    if [ "$1" == "WORDPRESS_DOMAIN" ]; then
        nginx_replace_domain "$value"
    fi
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

echo "Domain names in nginx.conf have been updated."
