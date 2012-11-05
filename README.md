## Weatherman

**Weatherman** is a utility to help report custom metrics from EC2 instances to CloudWatch.

## Usage

*Simple example*

```ruby
#Set credentials
Weatherman::AWS.aws_access_key_id = 'key_id'
Weatherman::AWS.aws_secret_access_key = 'key'

#Report a process count to CloudWatch
Weatherman::Report.run 'Process count' do
  `ps -ef | wc -l`
end
```

*Report options*

Report takes an optional hash as a second argument. Supported keys with the defaults, unless otherwise specified:

```ruby
{
  #Set the metric namespace
  :namespace => 'Custom/Weatherman',

  #Set the reporting period (in seconds)
  :period => 12,

  #Metadata for the metric, defaults to just InstanceId
  #InstanceId is always included, even when this is set
  :dimensions => {
    :instance_name => 'super_cool_instance',
    :deployment_id => 1
  }
}
```

*Daemonizing*

The gem installs a 'weatherman' executable to your path. Pass as many Weatherman scripts to it as you want, each of which will be loaded and run in the background.

## License

(The MIT License)

Copyright (c) 2012 Mike Marion

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
