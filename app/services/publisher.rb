class Publisher

  class << self

    def connection
      @connection ||= Bunny.new.tap do |c|
        c.start
      end
    end

    def channel
      @channel ||= connection.create_channel
    end

    def exchange
      @exchange ||= channel.fanout("user.changed")
    end

    def publish(message = '')
      exchange.publish(message, persistent: true)
    end
  end

end
