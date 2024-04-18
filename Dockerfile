FROM ruby:3.2.2
WORKDIR /app


# get node and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# get apt packages
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    nodejs \
    yarn && \
  rm -rf /var/lib/apt/lists/*

# get gems
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# install js packages
COPY package.json yarn.lock /app/
RUN yarn install

# precompile app assets
COPY . /app/
RUN bin/rails assets:precompile

EXPOSE 3000