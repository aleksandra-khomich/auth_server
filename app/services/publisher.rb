class Publisher

  class << self
    def publish(message = '')
      channel = channel.fanout("user.changed")
      channel.publish(message, persistent: true)
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
