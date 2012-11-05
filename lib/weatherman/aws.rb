module Weatherman
  module AWS

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

  end
end
