FROM alpine:3.3
RUN apk add \
  --update \
  curl \
  ruby \
  ruby-json \
  py-pip
RUN pip install awscli
RUN gem install --no-rdoc --no-ri cfndsl stackup
COPY .stack-work/install/x86_64-linux-ncurses6/lts-7.4/8.0.1/bin/cfn-deploy /usr/local/bin/
ENTRYPOINT ["cfn-deploy"]

