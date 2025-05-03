FROM ruby:3.4.3

ENV ROOT="/rails"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV RAILS_ENV=development

WORKDIR ${ROOT}

COPY Gemfile Gemfile.lock ${ROOT}

RUN gem install bundler && bundle install

COPY . ${ROOT}
