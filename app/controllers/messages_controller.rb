class MessagesController < ApplicationController
    before_action :initialize_managers
    def index
        verify_application_and_chat_identfier or return
        message_payload = {message: @chat_application.messages}
        render status: :ok, json: {messages: reform_list(message_payload)}
    end

    def show
        verify_application_and_chat_identfier or return
        verify_message_identifier_number or return
        message_payload = {message: @message_chat}
        render json: {message: reform(message_payload)}, status: :ok
    end

    def create
        verify_application_and_chat_identfier or return
        message_payload = {type: "create", message: message_body}
        Publisher.publish(message_payload)
        render status: :created, json: {message: reform(message_payload)}
    end

    def update
        verify_application_and_chat_identfier or return
        verify_message_identifier_number or return
        @message_chat.assign_attributes(body: message_text)
        message_payload = {type: "edit", message: @message_chat}
        Publisher.publish(message_payload)
        render status: :no_content, json: "The application's name was updated"
    end

    def search
        verify_application_and_chat_identfier or return 
        message_payload = {message: get_all_matched_text}
        render status: :ok, json: {messages: reform_list(message_payload)}
    end

    private
        def initialize_managers
            @message_manager = MessageManager.new
        end

        def message_text
            message_text_param = params[:message][:body]
            if message_text_param == nil or message_text_param.length < 1
                render status: 400, json: {error: "the body of message does not have to be empty"}
            else
                return message_text_param
            end
        end

        def verify_application_and_chat_identfier
            @application = Application.find_by_identifier_token(params[:applications_system_identifier_token])
            response_record_not_found("application identifier token") and return false unless @application
            @chat_application = @application.chats.find_by( :identifier_number => params[:chat_identifier_number])
            if @chat_application == nil 
                response_record_not_found("chat number")
            end
            return @chat_application
        end

        def verify_message_identifier_number
            @message_chat = @chat_application.messages.find_by( :identifier_number => params[:identifier_number])
            if @message_chat == nil 
                response_record_not_found("chat number")
            end
            return @message_chat
        end

        def response_record_not_found (invalid_parameter)
            render status: :bad_request, json: {error: "Ivalid #{invalid_parameter}"}
        end

        def get_all_matched_text
            @chat_application.messages.search(message_text || '').records.to_a
        end

        def message_body
            Message.new({
                chat_id: @chat_application.id,
                identifier_number: Message.where(chat_id: @chat_application.id).count + 1,
                body: message_text
            })
        end

        def reform_list(message_payload)
            all_messages_after_reform = []
            for message in message_payload[:message]
                all_messages_after_reform.append(MessageDto.new({message: message}));
            end
            return all_messages_after_reform
        end

        def reform(message_payload)
            MessageDto.new(message_payload)
        end

end
