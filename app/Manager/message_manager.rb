class MessageManager

    def create_message(message_payload)
        
        Message.create({
            chat_id: message_payload["message"]["chat_id"],
            identifier_number: message_payload["message"]["identifier_number"],
            body: message_payload["message"]["body"]
        })

    end

    def edit_message(message_payload)
        message = Message.find_by_id(message_payload["message"]["id"])
        message.assign_attributes(body: message_payload["message"]["body"])
        message.save
    end


end