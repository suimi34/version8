FROM ruby:3.4.5

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  && rm -rf /var/lib/apt/lists/*

# 2. Add Docker’s official GPG key and repository
RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) stable" \
  > /etc/apt/sources.list.d/docker.list

# 3. Install Docker CLI plugins
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  docker-ce-cli \
  docker-buildx-plugin \
  docker-compose-plugin \
  && rm -rf /var/lib/apt/lists/*

# 4. Verify versions
RUN docker --version && \
  docker buildx version && \
  docker compose version

ENV ROOT="/rails"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV RAILS_ENV=development

WORKDIR ${ROOT}

COPY Gemfile Gemfile.lock ${ROOT}

RUN gem install bundler && bundle install

COPY . ${ROOT}
