#!/bin/bash

# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y python3-pip python3-venv git nginx

# Create application directory
mkdir -p /home/ubuntu/app

# Clone the repository (replace with your repository URL)
# git clone https://github.com/yourusername/your-repo.git /home/ubuntu/app

# Set up Python virtual environment
cd /home/ubuntu/app
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set up systemd service
sudo cp afcon-chatbot.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable afcon-chatbot
sudo systemctl start afcon-chatbot

# Set up Nginx as reverse proxy
sudo tee /etc/nginx/sites-available/afcon-chatbot << EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the Nginx site
sudo ln -s /etc/nginx/sites-available/afcon-chatbot /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Remove default site if it exists
sudo nginx -t  # Test Nginx configuration
sudo systemctl restart nginx

# Set proper permissions
sudo chown -R ubuntu:ubuntu /home/ubuntu/app

echo "Setup completed successfully!" 