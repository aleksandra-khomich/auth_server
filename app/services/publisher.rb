class Publisher

  class << self
    def publish(message = '')
      ch = channel.fanout("user.changed")
      ch.publish(message)
    end

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      @connection ||= Bunny.new.tap do |c|
        c.start
      end
    end
  end

end
