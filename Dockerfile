# This Dockerfile is designed for development, if you want it for production, creates a new one for production or adds the proper production config.

FROM ruby:3.3.6

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  build-essential \
  curl \
  gnupg2

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Set working directory
WORKDIR /geo_api

# Copy Gemfiles first to install gems
COPY Gemfile /geo_api/Gemfile
COPY Gemfile.lock /geo_api/Gemfile.lock

# Install gems
RUN gem install bundler && bundle install

# Copy the whole project
COPY . /geo_api

# Expose port 3000
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
