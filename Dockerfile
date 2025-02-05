FROM ubuntu:latest

ARG TARGETARCH
RUN apt-get update
RUN apt install -y curl libicu-dev jq

# Install jekyll
RUN apt-get install -y ruby-full build-essential zlib1g-dev
# For jekyll-minifier
#RUN apt-get install -y nodejs

# For deploy to nginx
RUN apt-get install -y openssh-client rsync

WORKDIR /home/ubuntu
USER ubuntu

ENV GEM_HOME="/home/ubuntu/gems"
ENV PATH="/home/ubuntu/gems/bin:$PATH"
RUN gem install jekyll bundler

# install github runner
RUN mkdir actions-runner
WORKDIR /home/ubuntu/actions-runner
RUN if [ $TARGETARCH = "arm64" ]; then \
        curl -o actions-runner-linux-arm64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-arm64-2.321.0.tar.gz && \
        echo "62cc5735d63057d8d07441507c3d6974e90c1854bdb33e9c8b26c0da086336e1 actions-runner-linux-arm64-2.321.0.tar.gz" | sha256sum -c && \
        tar xzf ./actions-runner-linux-arm64-2.321.0.tar.gz && \
        rm -rf actions-runner-linux-arm64-2.321.0.tar.gz \
    ; fi
RUN if [ $TARGETARCH = "amd64" ]; then \
        curl -o actions-runner-linux-x64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz && \
        echo "ba46ba7ce3a4d7236b16fbe44419fb453bc08f866b24f04d549ec89f1722a29e  actions-runner-linux-x64-2.321.0.tar.gz" | sha256sum -c && \
        tar xzf ./actions-runner-linux-x64-2.321.0.tar.gz && \
        rm -rf actions-runner-linux-x64-2.321.0.tar.gz \
    ; fi

COPY home/ubuntu/actions-runner/add-runner.sh /home/ubuntu/actions-runner/add-runner.sh

CMD ["./add-runner.sh"]