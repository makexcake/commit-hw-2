# Application Branch
Branch for the app that displays an image from a private s3 bucket.
On branch push ci/cd pipeline is initiated and after 5 minutes the image on the page is updated.

## Files Description
* Application: The app uses AWS SDK library to pull image from s3 bucket.
* buildspec.yml: File with build instruction that is used by AWS CodeBuild
* imagedefinitions.json: file used by the deployment stage. Contains information about the service.

