FROM ruby:3.2.1 AS wow-ah-development

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /opt/app
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test

# Adding project files
COPY . .

EXPOSE 3000
# CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
