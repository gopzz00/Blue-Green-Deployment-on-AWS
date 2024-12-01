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
