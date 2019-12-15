# S3 AntiVirus with ClamAV

[![Gem Version](https://badge.fury.io/rb/s3-antivirus.png)](http://badge.fury.io/rb/s3-antivirus)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

Detects if files uploaded to s3 contain a virus with [ClamAV](https://www.clamav.net/) and auto-deletes or tags them.  Works by processing an SQS Queue that contain messages from [S3 Bucket Event Notifications](https://docs.aws.amazon.com/AmazonS3/latest/user-guide/enable-event-notifications.html).

## Usage

    s3-antivirus scan

## Installation

Add this line to your application's Gemfile:

    gem "s3-antivirus"

And then execute:

    bundle

Or install it yourself as:

    gem install s3-antivirus

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
