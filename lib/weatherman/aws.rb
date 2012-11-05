module Weatherman
  module AWS

    def self.aws_access_key_id
      @aws_access_key_id || ENV['AWS_ACCESS_KEY_ID']
    end

    def self.aws_access_key_id=(id)
      @aws_access_key_id = id
    end

    def self.aws_secret_access_key
      @aws_secret_access_key || ENV['AWS_SECRET_ACCESS_KEY']
    end

    def self.aws_secret_access_key=(key)
      @aws_secret_access_key = key
    end

    def self.region
      @region || 'us-east-1'
    end

    def self.region=(region)
      @region = region
    end

    def self.instance_id
      ec2_attributes[:instance_id]
    end

    def self.ec2_attributes
      unless @ohai
        @ohai = Ohai::System.new
        @ohai.all_plugins
        @ohai.refresh_plugins
      end
      @ohai.ec2 || {}
    end

    class CloudWatchMock
      def put_metric_data(*args); end
    end

    def cloud_watch
      #TODO: Update Fog with mock support for CloudWatch
      @cloud_watch ||= CloudWatchMock.new if Fog.mocking?

      @cloud_watch ||= Fog::AWS::CloudWatch.new(
        :region                => AWS.region,
        :aws_access_key_id     => AWS.aws_access_key_id,
        :aws_secret_access_key => AWS.aws_secret_access_key
      )
    end

  end
end
