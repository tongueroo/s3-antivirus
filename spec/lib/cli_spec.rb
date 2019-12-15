describe S3Antivirus::CLI do
  describe "s3-antivirus" do
    it "scan" do
      out = execute("exe/s3-antivirus scan --noop")
      expect(out).to include("Polling SQS queue")
    end
  end
end
