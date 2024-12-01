Here’s a simple **Blue-Green Deployment on AWS** project. This approach minimizes downtime and risk during deployments by switching between two environments: *blue* (current production) and *green* (new version).

---

## **Project Overview**
In this project, we implement a Blue-Green deployment for a web application hosted on AWS. The setup uses EC2 instances behind an Elastic Load Balancer (ELB). The *blue* environment serves live traffic, while the *green* environment is prepared with the new application version. After testing the *green* environment, traffic is shifted from the *blue* to the *green* environment.

---

## **Tech Stack**
- **AWS Services**: EC2, Elastic Load Balancer (ELB), Auto Scaling, Route 53.
- **Deployment Automation**: Terraform (or AWS CLI if Terraform is not preferred).
- **Application**: A simple Node.js or Python Flask app.

---

## **Steps to Implement**

### **1. Prerequisites**
- AWS account with CLI configured.
- Terraform installed (or use AWS CLI for manual setup).
- Docker installed for application containerization (optional).

---

### **2. Architecture**
The setup includes:
1. Two EC2 Auto Scaling groups (one for *blue*, one for *green*).
2. An ELB distributing traffic to the active environment.
3. Route 53 for DNS routing (optional, or you can use ELB DNS).

---

### **3. Step-by-Step Implementation**

#### **3.1. Clone the Repository**
```bash
git clone https://github.com/your-repo/blue-green-deployment-aws.git
cd blue-green-deployment-aws
```

---

#### **3.2. Application Setup**
Create a simple web application (e.g., Node.js or Flask):
- **Node.js Example**:
  ```javascript
  const http = require('http');

  const server = http.createServer((req, res) => {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello from the Blue environment!\n');
  });

  server.listen(3000, () => {
      console.log('Server running on port 3000');
  });
  ```
- Save this as `app.js`.

---

#### **3.3. Dockerize the Application (Optional)**
1. Create a `Dockerfile`:
   ```dockerfile
   FROM node:14
   COPY app.js /app.js
   CMD ["node", "app.js"]
   ```
2. Build and push the image to Docker Hub or ECR:
   ```bash
   docker build -t your-dockerhub-user/app-blue .
   docker push your-dockerhub-user/app-blue
   ```

---

#### **3.4. Infrastructure Setup with Terraform**

**Directory Structure**:
```
blue-green-deployment-aws/
├── terraform/
│   ├── main.tf          # AWS infrastructure definition
│   ├── variables.tf     # Variables for the setup
│   └── outputs.tf       # Outputs like ELB DNS
└── README.md
```

**Terraform `main.tf` Example**:
```hcl
provider "aws" {
  region = "us-east-1"
}

# Create a Load Balancer
resource "aws_lb" "web" {
  name               = "blue-green-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
}

# Target Groups for Blue and Green
resource "aws_lb_target_group" "blue" {
  name     = "blue-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "green" {
  name     = "green-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Listener for Load Balancer
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

# Auto Scaling Group for Blue and Green
resource "aws_autoscaling_group" "blue" {
  ...
}

resource "aws_autoscaling_group" "green" {
  ...
}
```

**Apply Terraform**:
```bash
terraform init
terraform apply
```

---

#### **3.5. Deploy the Blue Environment**
1. Launch the Blue environment with your application.
2. Verify the application by accessing the ELB DNS:
   ```bash
   curl http://<elb-dns-name>
   ```

---

#### **3.6. Deploy the Green Environment**
1. Update your application (change `Hello from Blue` to `Hello from Green`).
2. Deploy the updated version to the *green* Auto Scaling group.

---

#### **3.7. Test and Switch Traffic**
1. Test the *green* environment by directly accessing its target group.
2. If successful, update the ELB listener to forward traffic to the *green* target group:
   ```bash
   aws elbv2 modify-listener --listener-arn <listener-arn> \
     --default-actions Type=forward,TargetGroupArn=<green-target-group-arn>
   ```
3. Verify the deployment by accessing the ELB DNS again.

---

### **4. README.md**

Here's the **README.md** for your project:

---

# **Blue-Green Deployment on AWS**

## **Overview**
This project demonstrates a Blue-Green deployment for a web application hosted on AWS. The active environment (blue or green) serves live traffic, while the other is used for testing or deploying a new version.

---

## **Tech Stack**
- **AWS Services**: EC2, Elastic Load Balancer (ELB), Auto Scaling, Route 53.
- **Automation**: Terraform or AWS CLI.
- **Application**: Node.js-based sample web app.

---

## **Setup Instructions**

### **1. Prerequisites**
- AWS account and CLI configured.
- Terraform installed.

---

### **2. Steps**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/blue-green-deployment-aws.git
   cd blue-green-deployment-aws
   ```

2. **Provision Infrastructure**:
   - Navigate to the Terraform folder and apply the configuration:
     ```bash
     terraform init
     terraform apply
     ```

3. **Deploy the Blue Environment**:
   - Launch the blue environment with the initial application version.
   - Test the application at the ELB DNS.

4. **Deploy the Green Environment**:
   - Update the application and deploy it to the green environment.
   - Test the green environment by accessing its target group.

5. **Switch Traffic**:
   - Update the ELB listener to forward traffic to the green target group.
   - Verify the deployment by accessing the ELB DNS.

---

## **Results**
- Traffic switches seamlessly between environments with minimal downtime.
- The new version is tested in isolation before live deployment.

---

## **Future Enhancements**
- Automate the traffic switch using AWS CodeDeploy.
- Add a canary deployment strategy to test small traffic batches.
