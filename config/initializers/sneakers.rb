require 'sneakers'
Sneakers.configure(:amqp => "amqp://guest:guest@#{ENV['RABBITMQ_HOST']}:5672")
Sneakers.logger.level = Logger::INFO