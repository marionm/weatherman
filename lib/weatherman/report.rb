module Weatherman
  class Report

    attr_reader :name, :options

    def self.run(name, options = {}, &collector)
      report = new(name, options, &collector)
      report.run
      report
    end

    def initialize(name, options = {}, &collector)
      @name = name
      @collector = collector
      @period = options[:period] || 12
      #TODO: Get the instance ID from Ohai
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

      #TODO: Actually report it

      value
    end

  end
end
