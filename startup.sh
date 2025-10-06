#!/bin/bash

# Azure App Service startup script for Django
echo "Starting Django application..."

# Install dependencies
echo "Installing Python dependencies..."
python -m pip install --upgrade pip
pip install -r requirements.txt

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Run database migrations
echo "Running database migrations..."
python manage.py migrate --noinput

# Start Gunicorn server
echo "Starting Gunicorn server..."
gunicorn --bind=0.0.0.0 --timeout 600 cursor_portfolio.wsgi