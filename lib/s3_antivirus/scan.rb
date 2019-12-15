require "aws-sdk-sqs"
require "json"
require "securerandom"
require "syslog/logger"
require "uri"
require "yaml"

module S3Antivirus
  class Scan
    extend Memoist
    include AwsServices
    include Logger
    include Conf

    def initialize(options={})
      @options = options
    end

    def run
      logger.info "Polling SQS queue for S3 antivirus findings. Started #{Time.now}..."
      return if @options[:noop]

      poller = Aws::SQS::QueuePoller.new(conf['queue'])
      poller.poll do |msg|
        begin
          body = JSON.parse(msg.body)

          logger.debug "body #{body}"
          if body.key?('Records')
            body['Records'].each do |record|
              # Instance variables change on each iteration
              @s3_record = S3Record.new(record)
              @notifier = Notifier.new(@s3_record)
              @tagger = Tagger.new(@s3_record)

              logger.info("Checking #{@s3_record.human_key}")
              within_size_limit = check_file_size
              next unless within_size_limit # continue to next file because oversized
              filename = "/tmp/#{SecureRandom.uuid}"
              success = download_file(filename)
              next unless success # continue to next file because unable to download
              scan_file(filename)
            end
          end
        rescue Exception => e
          logger.error "message failed: #{e.inspect} #{msg.inspect}"
          raise e
        end
        # Sometimes stdout doesnt get shown but the message is processed file.
        # Know this because the SNS message gets sent.
        # Even this $stdout.flush doesn't seem to be enough.
        $stdout.flush
      end
    end

  private
    def scan_file(filename)
      logger.info "Scanning #{human_key}..."
      sh("clamdscan #{filename}")
      exitstatus = $?.exitstatus
      if exitstatus == 0 # No virus found.
        clean_file_found
      elsif exitstatus == 1 # Virus(es) found.
        virus_found
      else # An error occured.
        raise "#{human_key} could not be scanned, clamdscan exit status was #{exitstatus}, retry"
      end
    ensure
      system("rm #{filename}")
    end

    def clean_file_found
      if conf['tag_files']
        logger.info "#{human_key} is clean (tagging)"
        @tagger.tag("clean");
      else
        logger.info "#{human_key} is clean"
      end
      if conf['report_clean']
        @notifier.notify(status: "clean", action: "no");
      end
    end

    def virus_found
      if conf['delete']
        logger.info "#{human_key} is infected (deleting)"
        s3.delete_object(
          bucket: @s3_record.bucket,
          key: @s3_record.key,
        )
        @notifier.notify(status: "infected", action: "delete");
      elsif conf['tag_files']
        logger.info "#{human_key} is infected (tagging)"
        @tagger.tag("infected");
        @notifier.notify(status: "infected", action: "tag");
      else
        logger.info "#{human_key} is infected"
        @notifier.notify(status: "infected", action: "no");
      end
    end

    def human_key
      @s3_record.human_key
    end

    def download_file(filename)
      logger.info "Downloading #{@s3_record.human_key} to #{filename}..."
      params = {
        response_target: filename,
        bucket: @s3_record.bucket,
        key: @s3_record.key,
      }
      params[:version_id] = @s3_record.version if @s3_record.version

      begin
        s3.get_object(params)
      rescue Aws::S3::Errors::NoSuchKey
        logger.info "#{@s3_record.human_key} no longer exist, skipping."
        return false
      end
      true # successful download
    end

    def check_file_size
      within_size_limit = true
      if @s3_record.oversized?
        logger.info "#{@s3_record.human_key} is too large. Bigger than half of the EBS volume, skipping."
        if conf['tag_files']
          @tagger.tag("oversized")
        end
        @notifier.notify(status: "oversized", action: "no")
        within_size_limit = false
      end
      within_size_limit
    end

    def sh(command)
      logger.info("=> #{command}")
      system(command)
    end
  end
end
