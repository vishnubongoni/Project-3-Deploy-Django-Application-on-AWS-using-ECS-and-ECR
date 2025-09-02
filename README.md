# Simple Notes App
This is a simple notes app built with React and Django.

## Requirements
1. Python 3.9
2. Node.js
3. React

## Installation
1. Clone the repository
```
git clone https://github.com/anirudhadak2/django-notes-app.git
```

2. Build the app
```
docker build -t notes-app .
```

3. Run the app
```
docker run -d -p 8000:8000 anirudhadak2/new-app:my-note-app
```

## Nginx

Install Nginx reverse proxy to make this application available

`sudo apt-get update`
`sudo apt install nginx`

-----------------------------------------------------------------


This article will deploy a Django-based application onto AWS using ECS (Elastic Container Service) and ECR (Elastic Container Registry). We start by creating the docker image of our application and pushing it to ECR. After that, we create the instance and deploy the application on AWS using ECS. Next, we ensure the application is running correctly using Django’s built-in web server.

Docker Workflow
Docker is an open platform software. It is used for developing, shipping, and running applications. Docker virtualizes the operating system of the computer on which it is installed and running. It provides the ability to package and run an application in a loosely isolated environment called a container. A container is a runnable instance of a docker image. You can create, start, stop, move, or delete a container using the Docker API or CLI. You can connect a container to one or more networks, attach storage to it, or even create a new docker image based on its current state.


What is AWS Elastic Container Registry?
Amazon Elastic Container Registry (Amazon ECR) is a managed container image registry service. Customers can use the familiar Docker CLI, or their preferred client, to push, pull, and manage images. Amazon ECR provides a secure, scalable, and reliable registry for your Docker images.

ECR Steps
Here comes the task in which we create the repository on AWS using ECR where our application docker image will reside. To begin with the creation of a repository on ECR we first search ECR on AWS console and follows the below steps.

1.Create a Docker File — Add the “Dockerfile” to the Django application. It contains the series of command which will be required for the creation of docker image.

2.Build your Docker Image — Use the below command to create the docker image name as notes-app
``` docker build -t notes-app . ```

3.Check whether the docker image is created or not using the below command.
``` docker images | grep notes-app ```

4.Create Repository on AWS ECR — It's time to open the AWS console and search for ECR. Then, click on the Create Repository button.
You will find two options for the visibility of your repository i.e, Private and Public. The Private repository access is managed by IAM and repository policy permissions. Once you click on create repository button then, you need to give the name of your repository. If you enabled the scan on push option then, it helps in identifying software vulnerabilities in your container images.

5.Push the created docker image of the Django application on Step 2 to AWS ECR —
a) Authenticate your Docker client to the Amazon ECR registry. Authentication tokens must be obtained for each registry used, and these tokens are valid for 12 hours. The easiest way of doing this is to get the AWS AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. Then run the below command.
``` export AWS_ACCESS_KEY_ID=******
export AWS_SECRET_ACCESS_KEY=****** ```

After exporting the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, login to the AWS account using the below command.
``` aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com ```

b) Identify the image to push using the docker images command:

c)Tag your image with the Amazon ECR registry, repository, and optional image tag name combination to use. The registry format is aws_account_id.dkr.ecr.region.amazonaws.com. The repository name should match the repository that you created for your image.

The following example tags an image with the ID 480903dd8 as aws_account_id.dkr.ecr.region.amazonaws.com/notes-app.

``` docker tag 480903dd8 aws_account_id.dkr.ecr.region.amazonaws.com/notes-app ```

d) Push the docker image using the docker push command:
``` docker push aws_account_id.dkr.ecr.region.amazonaws.com/notes-app ```

What is AWS Elastic Container Service?
Amazon Elastic Container Service (ECS) is a highly scalable, high-performance container management service that supports Docker containers and allows you to easily run applications on a managed cluster of Amazon EC2 instances. With Amazon ECS we can install, operate and scale our application with its own cluster management infrastructure. Using some simple API calls, we can launch and stop our Docker-enabled applications, query the logs of our cluster, and access many familiar features like security groups, Elastic Load Balancer, EBS volumes, and IAM roles. We can use Amazon ECS to schedule the placement of containers across our cluster based on our resource needs and availability requirements. We can also integrate our own scheduler or third-party schedulers to meet business or application-specific requirements.

ECS Steps
Now the time has come to launch our first EC2 instance using AWS ECS. To begin with, let’s first search ECS on AWS console and follows the below steps.

1. Create a Cluster
In AWS Console, search for ECS.
Click Clusters → Create Cluster.
Select Networking only (Fargate) option (no need to provision EC2 instances).
Configure:
Cluster name
VPC & Subnets (choose existing or let ECS create new ones)
Enable Container Insights if needed.
Click Create.

2. Create a Task Definition (Fargate)
Navigate to Task Definitions → Create new Task Definition.
Choose Fargate as the Launch type.
Configure:
Task name
Task role (IAM role if containers need AWS access)
Task size (CPU & Memory)
Add container(s):
Image from ECR (Elastic Container Registry) or Docker Hub.
Port mappings (e.g., 8000 for Django app).
(Optional) Add volumes for persistent storage.
Save the task definition.

3. Create a Service to Run the Task
Go to Services → Create Service.
Select:
Launch type → Fargate
Cluster (the one you created)
Task Definition (created in step 2)
Service name
Desired tasks (how many replicas to run).
Configure networking:
VPC & Subnets
Security groups (open required ports, e.g., 8000/80).
Configure load balancer (optional but recommended if you need external access).
Create the service.

4. Run the Task
After the service is created, ECS will automatically launch tasks using Fargate.
No EC2 instance is needed — AWS provisions the compute for you.
You can monitor your running tasks in ECS → Cluster → Tasks.


5. Verify
Go to EC2 → Load Balancers (if you used one) or get the public IP of the ENI attached to your Fargate task.
Access your app (e.g., http://<public-ip>:8000).

CONGRATULATIONS......................
