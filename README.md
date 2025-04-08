# AFCON Chatbot

A Flask-based chatbot application for AFCON 2025 match information.

## Deployment to EC2 using GitHub Actions

### Prerequisites

1. An AWS EC2 instance running Ubuntu
2. A GitHub repository with your code
3. SSH access to your EC2 instance

### Setup Instructions

#### 1. EC2 Instance Setup

1. Launch an EC2 instance with Ubuntu (recommended: t2.micro or larger)
2. Configure security group to allow inbound traffic on ports 22 (SSH) and 80 (HTTP)
3. Connect to your EC2 instance via SSH
4. Run the setup script:

```bash
# Make the script executable
chmod +x setup-ec2.sh

# Run the setup script
./setup-ec2.sh
```

#### 2. GitHub Repository Setup

1. Add the following secrets to your GitHub repository (Settings > Secrets and variables > Actions):
   - `EC2_SSH_KEY`: Your EC2 instance's private SSH key
   - `EC2_HOST`: Your EC2 instance's public IP or domain
   - `EC2_USER`: The username on your EC2 instance (usually 'ubuntu')

2. Push your code to the main branch of your GitHub repository

#### 3. Deployment

The GitHub Actions workflow will automatically deploy your application whenever you push to the main branch. You can also manually trigger the workflow from the Actions tab in your GitHub repository.

### Manual Deployment (if needed)

If you need to manually deploy your application:

```bash
# SSH into your EC2 instance
ssh ubuntu@your-ec2-ip

# Navigate to your application directory
cd /home/ubuntu/app

# Pull the latest changes
git pull origin main

# Install dependencies
pip install -r requirements.txt
python -m spacy download en_core_web_sm

# Restart the application
sudo systemctl restart afcon-chatbot
```

### Troubleshooting

1. Check the application logs:
   ```bash
   sudo journalctl -u afcon-chatbot
   ```

2. Check Nginx logs:
   ```bash
   sudo tail -f /var/log/nginx/error.log
   sudo tail -f /var/log/nginx/access.log
   ```

3. Verify the service status:
   ```bash
   sudo systemctl status afcon-chatbot
   sudo systemctl status nginx
   ```

## Local Development

1. Clone the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   python -m spacy download en_core_web_sm
   ```
4. Run the application:
   ```bash
   python app.py
   ```

The application will be available at http://localhost:5000 