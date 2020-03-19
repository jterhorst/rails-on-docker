FROM ruby:2.4

ENV APP_DIR=/app

# base packages
RUN apt-get update -qq && curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y build-essential nodejs postgresql postgresql-contrib libstdc++6 libpq-dev g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x dirmngr gnupg software-properties-common libcurl4-openssl-dev
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && apt-get update -qq && apt-get install -y yarn

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test -j2

COPY . $APP_DIR
RUN chown -R nobody:nogroup $APP_DIR
USER nobody

RUN bundle exec rake assets:precompile

EXPOSE 8080

CMD [ "/app/docker/start.sh" ]
