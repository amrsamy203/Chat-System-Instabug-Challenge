class ChatManager

    def create_chat(chat_payload)
        Chat.create({
            identifier_number: chat_payload["chat"]["identifier_number"],
            application_id: chat_payload["chat"]["application_id"],
            message_count: chat_payload["chat"]["message_count"]
        })
    end

    def update_message_count(message_payload)

        chat = Chat.find_by_id(message_payload["message"]["chat_id"])
        chat.assign_attributes(message_count: chat.message_count + 1)
        chat.save
    end


end