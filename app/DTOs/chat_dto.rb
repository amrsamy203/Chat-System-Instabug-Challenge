class ChatDto
    attr_reader :identifier_number, :message_count

    def initialize(data)
        @identifier_number = data[:chat][:identifier_number]
        @message_count = data[:chat][:message_count]
    end

    def as_json(options = {})
        {
            identifier_number: identifier_number, 
            message_count: message_count
        }
    end

end