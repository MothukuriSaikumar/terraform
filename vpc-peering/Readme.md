# AWS Cross-Region VPC Peering Using Terraform

## 📌 Project Overview

This mini project demonstrates how to create a **cross-region VPC Peering connection using Terraform**.

The project creates two AWS VPCs in different regions and establishes private communication between them using **VPC Peering**.

Each VPC contains:

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance

The EC2 instances communicate with each other using their **private IP addresses** through the VPC Peering connection.

---

## 🏗️ Architecture

```text
                         AWS Account
                              |
            --------------------------------
            |                              |
            |                              |
    Primary Region                   Secondary Region
      (Region-1)                       (Region-2)
            |                              |
            |                              |
       Primary VPC                     Secondary VPC
       10.0.0.0/16                     10.1.0.0/16
            |                              |
            |                              |
       Public Subnet                   Public Subnet
       10.0.1.0/24                     10.1.1.0/24
            |                              |
         EC2-1                          EC2-2
            |                              |
            |                              |
            -------- VPC Peering ----------
                         |
                  Private Communication

📁 Project Structure
vpc-peering/
├── provider.tf
├── variables.tf
├── data.tf
├── main.tf
├── outputs.tf
└── README.md

🧠 Key Learnings

This project helped me understand the following concepts:

AWS VPCs are regional resources.
Cross-region Terraform deployments require multiple provider configurations.
Provider aliases help manage infrastructure across multiple AWS regions.
VPC Peering requires non-overlapping CIDR blocks.
Cross-region peering requires the peer_region configuration.
A VPC Peering connection alone does not enable communication.
Route tables must be configured on both sides.
Security Groups must allow the required traffic.
Terraform resource references create implicit dependencies.
depends_on can be used when explicit dependency ordering is required.
