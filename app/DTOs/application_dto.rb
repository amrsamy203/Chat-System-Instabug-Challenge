class ApplicationDto
    attr_reader :identifier_token, :name, :chat_count

    def initialize(data)
        @identifier_token = data[:application][:identifier_token]
        @name = data[:application][:name]
        @chat_count = data[:application][:chat_count]
    end

    def as_json(options = {})
        {
            identifier_token: identifier_token, 
            name: name,
            chat_count: chat_count
        }
    end

end