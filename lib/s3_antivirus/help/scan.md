## Example

    $ s3-antivirus scan
    Polling SQS queue for S3 antivirus findings. Started 2019-12-15 04:07:09 +0000...
    Checking s3://test-bucket/eicar.txt
    Downloading s3://test-bucket/eicar.txt to /tmp/b5e986d1-4356-454a-87fe-bc01e5747a7b...
    Scanning s3://test-bucket/eicar.txt...
    => clamdscan /tmp/b5e986d1-4356-454a-87fe-bc01e5747a7b
    /tmp/b5e986d1-4356-454a-87fe-bc01e5747a7b: Eicar-Test-Signature FOUND

    ----------- SCAN SUMMARY -----------
    Infected files: 1
    Time: 0.001 sec (0 m 0 s)
    s3://test-bucket/eicar.txt is infected (deleting)
    Checking s3://test-bucket/a.txt
    Downloading s3://test-bucket/a.txt to /tmp/56da4b41-a672-42d4-a766-1727f5dc256d...
    Scanning s3://test-bucket/a.txt...
    => clamdscan /tmp/56da4b41-a672-42d4-a766-1727f5dc256d
    /tmp/56da4b41-a672-42d4-a766-1727f5dc256d: OK

    ----------- SCAN SUMMARY -----------
    Infected files: 0
    Time: 0.001 sec (0 m 0 s)
    s3://test-bucket/a.txt is clean (tagging)
