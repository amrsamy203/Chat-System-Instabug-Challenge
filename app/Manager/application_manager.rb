class ApplicationManager

    def create_application(application_payload)
        Application.create({
            identifier_token: application_payload["application"]["identifier_token"],
            name: application_payload["application"]["name"],
            chat_count: application_payload["application"]["chat_count"]
        })
    end

    def edit_application(application_payload)
        application = Application.find_by_identifier_token(application_payload["application"]["identifier_token"])
        application.assign_attributes(name: application_payload["application"]["name"])
        application.save
    end

    def update_chat_count(chat_payload)
        application = Application.find_by_id(chat_payload["chat"]["application_id"])
        application.assign_attributes(chat_count: application.chat_count + 1);
        application.save
    end


end