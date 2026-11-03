FROM ruby:3.4.12

WORKDIR /app

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the Rails application
COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]