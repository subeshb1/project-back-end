FROM ruby:2.6.3-stretch

RUN mkdir -p /back-end

WORKDIR /back-end

COPY Gemfile /back-end/Gemfile
COPY Gemfile.lock /back-end/Gemfile.lock

RUN bundle install

COPY . /back-end


EXPOSE 3000

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]

RUN ln -s /dev/stdout ./log/production.log

# Start the main process.
CMD bash -c "SECRET_KEY_BASE=`openssl rand -hex 64` rails server -p 3000 -b 0.0.0.0"
