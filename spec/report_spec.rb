require File.expand_path('spec_helper', File.dirname(__FILE__))

module Weatherman
  describe Report do

    before do
      @report = Report.new 'test'
      @initial_thread_count = Thread.list.length
    end

    describe 'run' do
      it 'should create and run a report' do
        report = Report.run 'test' do; end
        report.should be_running
      end

      it 'should get the instance ID' do
        pending
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

        sleep 1.5
        calls.length.should == 2
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
        value = 'some metric value'
        report = Report.new 'test' do
          value
        end

        report.report.should == value
      end

      it 'should report the metric' do
        pending
      end
    end
  end
end
