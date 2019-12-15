require "aws-sdk-sqs"
require "recursive-open-struct"
require "ostruct"
require "json"
class Aws::SQS::QueuePoller
  @@msg = nil
  def self.msg=(val)
    @@msg = val
  end

  def poll
    yield(@@msg)
  end
end

describe S3Antivirus::Scan do
  before(:each) do
    Aws::SQS::QueuePoller.msg = RecursiveOpenStruct.new(body: body)
  end

  # Pretty causal test. Mocked out most of the methods.
  let(:null) { double(:null).as_null_object }
  let(:scan) do
    scan = S3Antivirus::Scan.new
    allow(scan).to receive(:download_file).and_return(true)
    allow(scan).to receive(:scan_file)
    scan
  end
  let(:body) { IO.read("spec/fixtures/sqs-event.json") }

  describe "Scan" do
    it "run" do
      scan.run
    end
  end
end
