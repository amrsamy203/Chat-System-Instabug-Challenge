# Chat System Instabug Challenge
    - I recently received this challenge to work on as part of the hiring process.
    - Because I had never used rails or ruby before, the code may not be up to RoR standards.

## Challenge Statement
The system should allow creating new applications where
each application will have a token(generated by the system) and a name(provided by the client).
The token is the identifier that devices use to send chats to that application.
Each application can have many chats. a chat should have a number. Numbering of chats in
each application starts from 1 and no 2 chats in the same application may have the same
number. The number of the chat should be returned in the chat creation request. A chat
contains messages and messages have numbers that start from 1 for each chat. The number of
the message should also be returned in the message creation request. The client should never
see the ID of any of the entities. The client identifies the application by its token and the chat by
its number along with the application token.
Add an endpoint for searching through messages of a specific chat. It should be able to partially
match messages’ bodies. You must use ElasticSearch for this.

- Notes:
    ● You’re only asked to build the API. No GUI is required.
    ● You should use Ruby on Rails(V5 or any latest version) for building the API and the
    workers. BONUS: You are encouraged to have the endpoints of chats and messages
    creation as a Golang app.
    ● The endpoints should be RESTful. You should provide endpoints for creating, updating
    and reading applications, chats that belong to a specific application(GET
    /applications/[application_token]/chats) and messages that belong to a specific chat.
    Make sure to have appropriate indices in place for these endpoints to be optimized.
    ● Use MySQL as your main datastore. You’re allowed to use any other component you
    need along with MySQL. You may want to check out REDIS.
    ● You should add a Readme containing instructions to run your code.

we need crate three models
- Application
- Chat
- Message

## My Approach
#### Step 0
I first read chapter 12 from System Design Interview: An Insider’s Guide (by Alex xu). This chapter takes about how Design a chat system.

Second I used Trello to split the whole project into small tasks [https://trello.com/invite/b/rlPo9JCY/ATTI30c0509d2d77b943d48dee0c4557ca3eC6584413/instabug-challenge]

#### Step 1
> Create Three Models
> - Application
> - Chat
> - Message
To generate those models in RoR                                                                              
    - ruby bin\rails g model Application identifier_token:string name:string chat_count:integer     
    - ruby bin\rails g model Chat identifier_number:integer message_count:integer application:references               
    - ruby bin\rails g model message identifier_number body:text chat:references

#### Step 2
Then Choose The appropirate Index can create easly
    - ruby bin\rails g migration AddIndexToChats identifier_number:index 
    - ruby bin\rails g migration AddIndexToMessages identifier_number:index

#### Step 3
Run database migrate to create the schema of the database.

#### Step 4
Then generate 3 Controller for (Application - Chat - Message)
    - ruby bin\rails g controller ApplicationsSystemController                                                                 
    - ruby bin\rails g controller ChatsController                                                                       
    - ruby bin\rails g controller MessagesController

#### Step 5
Then Create 3 DTOs classes to remove unnecessary data that must not be seen by the client such as the ID for all entities.

#### Step 6
Then implement all RESTFUL endpoints for each controller.

#### Step 7
I used RabbitMQ to handle a huge of multiple requests, so I used a rabbitMQ as message queueing to consume the multiple requests

#### Step 8
Create an endpoint for full-text-search using the concept of the ElasticSearch

#### Step 9
The final stage creates docker-file and docker-compose-file to define each image on a whole container and each image can depend on another image

### What You Need To Run This Project
    - Download This Repository
    - Setup Docker
    - Open the cmd on the project location
    - Write this comand docker-compose up

### List of commands to test the app. You can use the postman and from file choose import and choose the Raw Text and Past the curl request

#### Create New Application

'''sh
curl --location --request POST 'http://localhost:3000/applications' \
--header 'Content-Type: application/json' \
--data-raw '{
    "application":
    {
        "name": "slack"
    }
}'

#### After creating a New Application you can use the application_token that generate from the previous request To create a chat
curl --location --request POST 'http://localhost:3000/applications/application_token/chats'

#### To create a Message To a specific chat you must have the identifier_number which generated from the previous request
curl --location --request POST 'http://localhost:3000/applications/application_token/chats/chat_identifier_number/messages' \
--header 'Content-Type: application/json' \
--data-raw '{
    "message":
    {
        "body": "wtite here your message"
    }
}'

#### Elasticsearch partial search a text in a specific chat
curl --location --request POST 'http://localhost:3000/applications/application_token/chats/chat_identifier_number/messages/search' \
--header 'Content-Type: application/json' \
--data-raw '{
    "message":
    {
        "body": "wtite here your text"
    }
}'


## TODO

- Model values validation
- Try to how use redis good
- Write specs to test the endpoints, add happy and unhappy scenarios.