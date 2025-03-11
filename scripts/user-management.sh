#!/bin/bash

# user-management.sh

# User Management Script
# Author: Tseggai Kidane
# Description: Script to add, delete, list, and manage Linux users

# Ensure the script is run as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Function to create a new user
create_user() {
    read -p "Enter username: " username
    read -s -p "Enter password: " password
    echo
    useradd -m "$username" -s /bin/bash
    echo "$username:$password" | chpasswd
    echo "User $username created successfully."
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    read -p "Delete home directory? (y/n): " delete_home
    if [[ "$delete_home" == "y" ]]; then
        userdel -r "$username"
    else
        userdel "$username"
    fi
    echo "User $username deleted successfully."
}

# Function to list all users
list_users() {
    cut -d: -f1 /etc/passwd
}

# Function to change a user's password
change_password() {
    read -p "Enter username: " username
    read -s -p "Enter new password: " password
    echo
    echo "$username:$password" | chpasswd
    echo "Password for $username changed successfully."
}

# Function to bulk create users from a file
bulk_create_users() {
    read -p "Enter file path (username:password per line): " file
    while IFS=: read -r username password; do
        useradd -m "$username" -s /bin/bash
        echo "$username:$password" | chpasswd
        echo "User $username created."
    done < "$file"
}

# Display menu
while true; do
    echo "User Management Script"
    echo "1) Create User"
    echo "2) Delete User"
    echo "3) List Users"
    echo "4) Change User Password"
    echo "5) Bulk Create Users"
    echo "6) Exit"
    read -p "Choose an option: " choice
    case "$choice" in
        1) create_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) change_password ;;
        5) bulk_create_users ;;
        6) exit 0 ;;
        *) echo "Invalid option." ;;
    esac
done

