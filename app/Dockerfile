FROM ruby:3.2.2

COPY ./src /app/src
WORKDIR /app/app

COPY ./src/Gemfile ../src/Gemfile
COPY ./src/Gemfile.lock ../src/Gemfile.lock
RUN cd ../src && bundle install \
    && apt-get update \
    && apt-get install -y default-mysql-client