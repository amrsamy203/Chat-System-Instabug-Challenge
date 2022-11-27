class Publisher
    # In order to publish message we need a exchange name.
    # Note that RabbitMQ does not care about the payload -
    # we will be using JSON-encoded strings
    def self.publish(queued_job)
      connection = Bunny.new(hostname: "rabbitmq:5672").start
      work_queue = connection.create_channel.queue('instaapi.chats', durable: true)
      work_queue.publish(queued_job.to_json.to_s)
      connection.close
    end
end