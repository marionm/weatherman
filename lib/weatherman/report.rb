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
        while true
          report
          sleep @period
        end
      end
    end

    def stop
      @thread.kill if @thread
      @thread = nil
    end

    def running?
      !@thread.nil?
    end

    def report
      value = @collector.call

      cloud_watch.put_metric_data @namespace, [{
        'MetricName' => @name,
        'Value'      => value,
        'Dimensions' => @dimensions.map { |k, v| { k.to_s => v } }
      }]

      value
    end

  end
end
