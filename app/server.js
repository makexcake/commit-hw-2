const express = require('express');
const AWS = require('aws-sdk');
const path = require('path');
const Stream = require('stream');

const app = express();

// Set up AWS SDK and the S3 client

AWS.config.update({
  region:'eu-central-1', // replace 'your-region' with your AWS region
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
});

AWS.config.update({region:'eu-central-1'});
const s3 = new AWS.S3();

// Hi Yuri, you are welcome to change the image placeholder
// to one of the following values and observe the changes after 5 minutes 
// in the alb link (I'll send it via e-mail)
// the values commit-logo.jpg, putin-hui.jpg, putin-monke.jpg
app.get('/image', function (req, res) {
  const s3params = {
    Bucket: 'commit-task-2',
    Key: 'commit-logo.jpg' // <-- change here
  };

  s3.getObject(s3params, (err, data) => {
    if (err) {
      console.log(err, err.stack);
      res.status(500).send("Error fetching image");
    } else {
      const img = new Stream.PassThrough();
      img.end(data.Body);
      res.set({
        'Content-Type': 'image/jpeg', 
        'Content-Length': data.ContentLength,
        'Last-Modified': data.LastModified,
        'ETag': data.ETag
      });
      img.pipe(res);
    }
  });
});

// Route handler for the homepage
app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
app.listen(3000, function () {
  console.log("App listening on port 3000!");
});
