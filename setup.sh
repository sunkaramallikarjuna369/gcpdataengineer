#!/bin/bash

# GCP Data Engineering 360° - Setup Script
# This script configures your environment for the learning repository

set -e

echo "=============================================="
echo "  GCP Data Engineering 360° - Setup Script   "
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check Python version
echo "Checking Python version..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    print_status "Python $PYTHON_VERSION found"
else
    print_error "Python 3 is not installed. Please install Python 3.9+"
    exit 1
fi

# Check if pip is installed
echo "Checking pip..."
if command -v pip3 &> /dev/null; then
    print_status "pip is installed"
else
    print_error "pip is not installed. Please install pip"
    exit 1
fi

# Create virtual environment
echo ""
echo "Creating virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    print_status "Virtual environment created"
else
    print_warning "Virtual environment already exists"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
print_status "Virtual environment activated"

# Install Python dependencies
echo ""
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
print_status "Python dependencies installed"

# Check for gcloud CLI
echo ""
echo "Checking Google Cloud SDK..."
if command -v gcloud &> /dev/null; then
    GCLOUD_VERSION=$(gcloud --version 2>&1 | head -n1)
    print_status "$GCLOUD_VERSION found"
else
    print_warning "Google Cloud SDK not found"
    echo "Install it from: https://cloud.google.com/sdk/docs/install"
    echo ""
    read -p "Would you like to install Google Cloud SDK now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl https://sdk.cloud.google.com | bash
        exec -l $SHELL
    fi
fi

# Check for Terraform
echo ""
echo "Checking Terraform..."
if command -v terraform &> /dev/null; then
    TERRAFORM_VERSION=$(terraform --version 2>&1 | head -n1)
    print_status "$TERRAFORM_VERSION found"
else
    print_warning "Terraform not found"
    echo "Install it from: https://www.terraform.io/downloads"
fi

# Check for Docker
echo ""
echo "Checking Docker..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version 2>&1)
    print_status "$DOCKER_VERSION found"
else
    print_warning "Docker not found (optional, for local simulations)"
fi

# Create .env file template
echo ""
echo "Creating environment template..."
if [ ! -f ".env" ]; then
    cat > .env << EOF
# GCP Data Engineering 360° - Environment Variables
# Copy this file to .env and fill in your values

# Google Cloud Project
GCP_PROJECT_ID=your-project-id
GCP_REGION=us-central1
GCP_ZONE=us-central1-a

# BigQuery
BQ_DATASET=gcp_data_engineering_labs
BQ_LOCATION=US

# Cloud Storage
GCS_BUCKET=your-bucket-name

# Pub/Sub
PUBSUB_TOPIC=gcp-data-eng-topic
PUBSUB_SUBSCRIPTION=gcp-data-eng-sub

# Dataflow
DATAFLOW_TEMP_LOCATION=gs://your-bucket/temp
DATAFLOW_STAGING_LOCATION=gs://your-bucket/staging

# Service Account (optional - for local development)
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account-key.json
EOF
    print_status "Environment template created (.env)"
else
    print_warning ".env file already exists"
fi

# Create directories for labs
echo ""
echo "Setting up lab directories..."
mkdir -p data/raw
mkdir -p data/processed
mkdir -p outputs
mkdir -p logs
print_status "Lab directories created"

# Verify GCP authentication
echo ""
echo "Checking GCP authentication..."
if gcloud auth list 2>&1 | grep -q "ACTIVE"; then
    ACTIVE_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
    print_status "Authenticated as: $ACTIVE_ACCOUNT"
else
    print_warning "Not authenticated with GCP"
    echo "Run 'gcloud auth login' to authenticate"
fi

# Summary
echo ""
echo "=============================================="
echo "  Setup Complete!                            "
echo "=============================================="
echo ""
echo "Next steps:"
echo "1. Copy .env.example to .env and fill in your GCP project details"
echo "2. Run 'gcloud auth login' if not authenticated"
echo "3. Run 'gcloud config set project YOUR_PROJECT_ID'"
echo "4. Start with the gcp-fundamentals module"
echo ""
echo "To activate the virtual environment in the future:"
echo "  source venv/bin/activate"
echo ""
echo "To launch the interactive 3D map:"
echo "  python -m http.server 8000"
echo "  Then open http://localhost:8000/index.html"
echo ""
echo "Happy learning!"
