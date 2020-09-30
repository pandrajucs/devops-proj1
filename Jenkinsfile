pipeline{
agent any
stages{
stage('terraform init'){
steps{
sh "terraform init"
sh "terraform apply --auto-approve"
    }
  }
 }
}

