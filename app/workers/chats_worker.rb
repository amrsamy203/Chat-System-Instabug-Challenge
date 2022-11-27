require 'bunny'
require 'sneakers'
class ChatsWorker
    include Sneakers::Worker
    from_queue "instaapi.chats", env: nil

    def work(payload)
        payload = JSON.parse(payload)
        application_manager = ApplicationManager.new
        chat_manager = ChatManager.new
        message_manager = MessageManager.new
        if payload["type"] == "create"
            if payload.key? "application"
                application_manager.create_application(payload)
            elsif payload.key? "chat"
                chat_manager.create_chat(payload)
                application_manager.update_chat_count(payload)
            elsif payload.key? "message"
                message_manager.create_message(payload)
                chat_manager.update_message_count(payload)
            end
        elsif payload["type"] == 'edit'
            if payload.key? "application"
                application_manager.edit_application(payload)
            elsif payload.key? "message"
                message_manager.edit_message(payload)
            end
        end
        ack!
    end

end