# syntax=docker/dockerfile:1
FROM ruby:3.2.3-slim

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH="/bundle" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libpq-dev \
      curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem update --system --no-document && \
    gem install bundler --no-document && \
    bundle install

# App code
COPY . .

# Build assets (tailwindcss-rails)
RUN bundle exec rails tailwindcss:build && \
    bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-lc", "bundle exec rails db:prepare && bundle exec puma -C config/puma.rb"]
