# Build, Deploy and Test allo-backend

## Prerequisites

Before you build the infrastructure or test the app please meet the following requirements:

#### Install Docker

Follow official guidelines to install docker in your system.

Verify that you can run Docker:

```bash
docker --version
```


#### Install Terraform

Follow official guidelines to install terraform in your system

Verify that you can run Terraform:

```bash
terraform version
```

#### Install AWS CLI

Follow official guidelines to install AWS CLI in your system.

To ensure that AWS CLI is installed properly, run the following command:

```bash
aws --version
```

Run `aws configure` to configure your region. Leave all the other fields blank. You should have something like:

```
admin:~/environment $ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: us-east-1
Default output format [None]: 
```

#### Clone the source code repository

```bash
git clone https://github.com/yagarwal1307/allo-backend
```
## Properly set environment variables

These variables will be used to build your container image and repo on ecr with the following names:

```
export REPOSITORY_NAME=allo-backend
export IMAGE_NAME=allo-backend
```

## Build and tag the Allo-Backend docker image

Change directory to allo-backend: 

```bash
cd allo-backend
```

From the allo-backend directory:

```bash
docker build -t $IMAGE_NAME .
```

## Run Allo-Backend application locally

First of all copy .env.example file to .env in your system:

```bash
cp .env.example .env
```

Now, there are two ways you can run Allo-backend locally:

#### With database also running locally:

Update the .env file as per your needs but DON'T CHANGE MONGO HOSTNAME in this case otherwise your application wont be able to communicate with the database:

To do this use docker compose command which will spin up a container with mongodb database as well:

```bash
docker compose up
```

After you are done running the app use following command to clean all the containers:

```bash
docker compose down
```


#### With database running remotely (for example on mongodb atlas)

Feel free to change the environment variables inside the .env file as per your need.

```bash
docker container run --rm -p 3000:3000 --env-file .env --name allo-backend $IMAGE_NAME
```
`Make sure that the port (3000 here) used above is same as SERVER_PORT variable used inside your .env file and make sure to set NODE_ENV to production in this case`

rm flag above makes sure to automatically remove your container after you have stopped it.


## Provision Infrastructure using terraform

First set your aws specific environment variables: 

```bash
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```
The following variables will be used in terraform later so run the following commands:

```bash
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
AWS_REGION=$(aws configure get region)
```

#### Provision an ECR Repository on aws using aws cli and push your docker image to it

```bash
aws ecr create-repository \
    --repository-name $REPOSITORY_NAME \
    --image-scanning-configuration scanOnPush=true \
    --region $AWS_REGION
	
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

docker tag $IMAGE_NAME $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME

docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME
```
#### Provision Apprunner infrastructure using terraform

First change directory to allo-infra (assuming you are in allo-backend directory, run following command) and set up terraform variables file:

```bash
cd ../allo-infra
cp .terraform.tfvars.example .terraform.tfvars
```
Set up all the required terraform variables. Replace the IMAGE_URL variable value with the output of following command:

```bash
echo $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME
```
Make sure your AWS_REGION terraform variable is same as AWS_REGION environment variable.

Now run the following commands to provision infrastructure using terraform:

```bash
terraform init
terraform plan
terraform apply
```
Save the url of your backend as follows:

``` bash
export apprunner_service_url_http=$(terraform output --raw apprunner_service_url)
```
After your are done using your app free all the aws resources using the following commands:

```bash
terraform destroy

aws ecr delete-repository \
    --repository-name $REPOSITORY_NAME \
	--region $AWS_REGION \
    --force
```
