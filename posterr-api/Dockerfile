FROM ruby:3.1.2-alpine
ENV BUNDLER_VERSION=2.3.7
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata

RUN gem install bundler -v 2.3.7
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install
COPY . ./
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]