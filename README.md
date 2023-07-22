# Commit Homework 2
Hello! Welcome to the homework repo.

## Description
The repo consists of the following branches:
* main (this)
* feature/application: Branch with the application and files for codepipeline. On every push the pipeline initiates and deploys the app.
* feature/terraform: terraform branch for setting up the requested infrastructure including the CodePipeline. Feuture plan: devide the template into my own modules.
* feature/cloudformation: Provisions the same infrastructure as the terraform branch (without the CodePipeline). The best practice it to devide it into separate templates to make the stack modular but I'll fix the application before I'll start.

### Notes tips and tricks will be appriciated.