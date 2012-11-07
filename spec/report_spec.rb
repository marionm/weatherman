require File.expand_path('spec_helper', File.dirname(__FILE__))

module Weatherman
  describe Report do

    before do
      @initial_thread_count = Thread.list.length

      @instance_id = 'i-test'
      AWS.should_receive(:instance_id).at_least(:once).and_return(@instance_id)

      @namespace = 'TestNamespace'
      @metric_name = 'TestMetric'
      @metric_value = 'some metric value'
      @report = Report.new @metric_name, :namespace => @namespace do
        @metric_value
      end
    end

    describe 'run' do
      it 'should create and run a report' do
        report = Report.run 'test' do; end
        report.should be_running
      end
    end

    describe 'run' do
      it 'should start a thread' do
        @report.run

        Thread.list.length.should == @initial_thread_count + 1
      end

      it 'should periodically call report' do
        calls = []
        report = Report.new 'test', :period => 1 do
          calls << true
        end

        report.run

        sleep 2
        calls.length.should >= 2
      end

      it 'should do nothing if already running' do
        @report.run

        @report.run

        Thread.list.length.should == @initial_thread_count + 1
      end
    end

    describe 'stop' do
      it 'should stop running report' do
        @report.run

        @report.stop

        @report.should_not be_running
        sleep 0.1
        Thread.list.length.should <= @initial_thread_count
      end

      it 'should do nothing if not running' do
        @report.stop

        @report.should_not be_running
        Thread.list.length.should <= @initial_thread_count
      end
    end

    describe 'running?' do
      it 'should be true if the report is running' do
        @report.run

        @report.should be_running
      end

      it 'should be false if the report is not running' do
        @report.should_not be_running
      end

      it 'should be false if the report is stopped' do
        @report.run

        @report.stop

        @report.should_not be_running
      end
    end

    describe 'report' do
      it 'should collect the metric' do
        @report.report.should == @metric_value
      end

      it 'should report the metric' do
        @report.cloud_watch.should_receive(:put_metric_data) do |namespace, metrics|
          namespace.should == @namespace

          metrics.length.should == 1
          metric = metrics.first

          metric['MetricName'].should == @metric_name
        end

        @report.report
      end

      it 'should include the instance ID as a default dimension' do
        @report.cloud_watch.should_receive(:put_metric_data) do |namespace, metrics|
          metrics.length.should == 1

          metric = metrics.first
          dimensions = metric['Dimensions']

          dimensions.length.should == 1
          dimensions.first['InstanceId'].should == @instance_id
        end

        @report.report
      end

      it 'should include user-defined dimensions plus the instance ID' do
        user_dimensions = {
          :alpha => 'beta',
          :gamma => 'delta'
        }
        report = Report.new @metric_name, :namespace => @namespace, :dimensions => user_dimensions do
          @metric_value
        end

        report.cloud_watch.should_receive(:put_metric_data) do |namespace, metrics|
          metrics.length.should == 1

          metric = metrics.first
          dimensions = metric['Dimensions']

          dimensions.length.should == 3

          user_dimensions['InstanceId'] = @instance_id
          user_dimensions.each do |k, v|
            dimension = dimensions.find { |d| d.keys.first == k.to_s}
            dimension.should_not be_nil
            dimension.length.should == 1
            dimension.values.first.should == v
          end
        end

        report.report
      end
    end

  end
end
