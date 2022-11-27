#!/usr/bin/env bash
echo "waiting for database to start..."
/wait.sh
echo "setting up database..."
bundle exec rails db:create && bundle exec rails db:migrate
echo "starting workers..."
rake sneakers:run
RUN rm -rf /var/lib/apt/lists/*
echo "starting application server..."
rm -f tmp/pids/server.pid
bundle exec rails s -p 3000 -b '0.0.0.0'