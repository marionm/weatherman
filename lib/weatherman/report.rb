module Weatherman
  class Report

    include AWS

    attr_reader :name, :options

    def self.run(name, options = {}, &collector)
      report = new(name, options, &collector)
      report.run
      report
    end

    def initialize(name, options = {}, &collector)
      @name       = name
      @collector  = collector
      @namespace  = options[:namespace] || 'Custom/Weatherman'
      @period     = options[:period] || 12
      @dimensions = options[:dimensions] || {}

      @dimensions.merge! 'InstanceId' => AWS.instance_id
    end

    def run
      @thread ||= Thread.new do
        broadcast sample_metric while sleep @period
      end
    end

    def stop
      @thread.kill if @thread
      @thread = nil
    end

    def running?
      !@thread.nil?
    end

    def sample_metric
      @collector.call
    end

    def broadcast(value)
      begin
        cloud_watch.put_metric_data @namespace, [{
          'MetricName' => @name,
          'Value'      => value,
          'Dimensions' => @dimensions.map { |k, v| { k.to_s => v } }
        }]
      rescue
        #TODO: Add loggging here, and throughout the gem
      end
    end

  end
end
