class MessageDto
    attr_reader :identifier_number, :body

    def initialize(data)
        @identifier_number = data[:message][:identifier_number]
        @body = data[:message][:body]
    end

    def as_json(options = {})
        {
            identifier_number: identifier_number, 
            body: body
        }
    end

end