$stdout.sync = true unless ENV["S3_ANTIVIRUS_STDOUT_SYNC"] == "0"

$:.unshift(File.expand_path("../", __FILE__))
require "memoist"
require "rainbow/ext/string"
require "s3_antivirus/version"

require "s3_antivirus/autoloader"
S3Antivirus::Autoloader.setup

module S3Antivirus
  class Error < StandardError; end
end
