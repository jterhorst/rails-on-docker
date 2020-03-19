#!/bin/sh

# Wait for the database
./docker/wait-for-postgres.sh db echo "Database is up!"

export POSTGRES_USER=$POSTGRES_USER
export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
echo '*:*:*:*:$POSTGRES_PASSWORD' > ~/.pgpass
unset $POSTGRES_PASSWORD

if echo "select * from schema_migrations;" | psql -h db -U $POSTGRES_USER -d prod  ; then
  echo "Database exists. Not initializing."
else
  echo "Initializing database..."
  bin/rake db:setup
fi

exec bundle exec puma -C config/puma.rb
