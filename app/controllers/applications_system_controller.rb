class ApplicationsSystemController < ApplicationController
    before_action :initialize_managers
    
    def create
        application_payload = {type: "create", application: application_body}
        Publisher.publish(application_payload)
        render status: :created, json: {application: reform(application_payload)}
    end

    def show
        verify_application_identfier_token or return
        application_payload = {application: @application}
        render status: :created, json: {application: reform(application_payload)}
    end

    def update
        verify_application_identfier_token or return
        @application.assign_attributes(name: application_params[:name])
        Publisher.publish({type: "edit", application: @application})
        render status: :no_content, json: "The application's name was updated"
    end

    private
        def initialize_managers
            @application_manager = ApplicationManager.new
        end
        def application_params
            #whitelist params
            params.require(:application).permit(:name)
        end

        def generate_application_token
            random_token = SecureRandom.urlsafe_base64(nil, false)
        end

        def verify_application_identfier_token
            # get and vlidate the existence of the record has the identifier_token from database
            @application = Application.find_by_identifier_token(params[:identifier_token])
            response_record_not_found and return false unless @application
            true
        end

        def response_record_not_found
            render status: :not_found, json: "No application was found with the provided identifier token"
        end

        def application_body
            Application.new({
                name: application_params[:name],
                identifier_token: generate_application_token,
                chat_count: 0
            })
        end

        def reform(application_payload)
            ApplicationDto.new(application_payload)
        end

end
