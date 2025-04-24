Project Structure
***********************
aws-key-rotation/
├── lambda/
│   └── rotate_keys.py
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── README.md


# 🔐 AWS Access Key Rotation with Lambda and Terraform

This project sets up an AWS Lambda function to automatically rotate an IAM user's access and secret keys. It uses:

- **Python** for the Lambda function logic
- **Terraform** to provision AWS infrastructure

## 🛠 Prerequisites

- AWS CLI configured
- Terraform installed
- IAM user whose keys will be rotated
- Optional: AWS Secrets Manager to store new credentials

## 🚀 Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/your-repo/aws-key-rotation.git
cd aws-key-rotation/terraform


What It Does

Lists current access keys for the user
Creates a new access key
Optionally stores the new keys in Secrets Manager
Deletes the old keys (except the new one)

Security

Make sure the IAM role only has access to the specific user or secret.
Rotate keys regularly via scheduled Lambda triggers (e.g., with EventBridge).
