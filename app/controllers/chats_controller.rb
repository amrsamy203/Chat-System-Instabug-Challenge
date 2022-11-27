class ChatsController < ApplicationController
    before_action :initialize_managers
    def index
        verify_application_identfier_token or return
        chat_payload = { chat:  @application.chats}
        render status: :ok, json: {chats: reform_list(chat_payload)}
    end

    def create
        verify_application_identfier_token or return
        chat_payload = {type: "create", chat: chat_body}
        Publisher.publish(chat_payload)
        render status: :created, json: {chat: reform(chat_payload)}
    end

    def show
        verify_application_identfier_token or return
        verify_chat_identifier_number or return
        chat_payload = {chat: @chat_application}
        render status: :ok, json: {chat: reform(chat_payload)}
    end


    private
    
        def initialize_managers
            @chat_manager = ChatManager.new
        end

        def verify_application_identfier_token
            @application = Application.find_by_identifier_token(params[:applications_system_identifier_token])
            response_record_not_found("application identifier token") and return false unless @application
            true
        end
    
        def verify_chat_identifier_number
            @chat_application = @application.chats.find_by( :identifier_number => params[:identifier_number])
            if @chat_application == nil 
                response_record_not_found("chat number")
            end
            return @chat_application
        end

        def response_record_not_found (invalid_parameter)
            render status: :bad_request, json: {error: "Ivalid #{invalid_parameter}"}
        end

        def chat_body
            Chat.new({
                application_id: @application.id,
                identifier_number: Chat.where(application_id: @application.id).count + 1,
                message_count: 0
            })
        end

        def reform_list(chat_payload)
            all_chats_after_reform = []
            for chat in chat_payload[:chat]
                all_chats_after_reform.append(ChatDto.new({chat: chat}));
            end
            return all_chats_after_reform
        end

        def reform(chat_payload)
            ChatDto.new(chat_payload)
        end
end
