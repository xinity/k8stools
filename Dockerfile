FROM ruby:2.5-alpine

LABEL maintainer="Rachid Zarouali <xinity77@gmail.com>"

RUN apk update && \
    apk add --no-cache git zsh curl tmux python bash vim && \
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true \
    && rm -f /tmp/* /etc/apk/cache/*

WORKDIR /usr/local/bin
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz \
    && tar -zxvf helm-v2.11.0-linux-amd64.tar.gz \
    && mv linux-amd64/helm ./ \
    && chmod +x helm \
    && rm -rf linux-amd64 helm-v2.11.0-linux-amd64.tar.gz \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && rm -rf get-pip.py \
    && pip install --no-cache-dir kube-shell \
    && git clone https://github.com/jordanwilson230/kubectl-plugins.git \
    && bash kubectl-plugins/install-kubectl-plugins

RUN gem install --no-document --minimal-deps tmuxinator

RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz \
    && tar -zxvf ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz \
    && mv ripgrep-0.10.0-x86_64-unknown-linux-musl/rg ./ \
    && rm -rf ripgrep-0.10.0-x86_64-unknown-linux-musl/ 

RUN curl -LO https://github.com/sharkdp/fd/releases/download/v7.1.0/fd-v7.1.0-x86_64-unknown-linux-musl.tar.gz \
    && tar -zxvf fd-v7.1.0-x86_64-unknown-linux-musl.tar.gz \
    && mv fd-v7.1.0-x86_64-unknown-linux-musl/fd ./ \
    && rm -rf fd-v7.1.0-x86_64-unknown-linux-musl/

RUN curl -Lo kubebox https://github.com/astefanutti/kubebox/releases/download/v0.3.0/kubebox-linux \
    && chmod +x kubebox
RUN curl -Lo kubetail https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail \
    && chmod +x kubetail

#RUN sh -c "git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k/" \
#    sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd 

#RUN curl -LO https://github.com/sharkdp/bat/releases/download/v0.7.1/bat-v0.7.1-x86_64-unknown-linux-musl.tar.gz \
#    && tar -zxvf bat-v0.7.1-x86_64-unknown-linux-musl.tar.gz

# curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.sh | bash
# https://github.com/jonmosco/kube-tmux
# RUN sh -c "git clone https://github.com/jonmosco/kube-tmux.git"
# RUN sh -c "git clone https://github.com/tony/tmux-config.git .tmux"
# RUN sh -c "git clone https://github.com/ryanoasis/nerd-fonts.git"
# RUN sh -c "~/nerd-fonts/install.sh" \

COPY zshrc /root/.zshrc

ENV SHELL /bin/zsh

CMD ["zsh", "--version"]
