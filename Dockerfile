FROM debian:stable 

ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install --no-install-recommends -y \
  apt-transport-https \
  autoconf \
  automake \
  ca-certificates \
  cmake \
  ripgrep \
  coreutils \
  curl \
  locales \
  doxygen \
  g++ \
  gettext \
  git \
  gnupg \
  libtool \
  libtool-bin \
  make \
  pkg-config \
  sudo \
  tar \
  unzip \
  wget \
  zip \
&& rm -rf /var/lib/apt/lists/*

# Download and build Neovim from latest source
RUN git clone https://github.com/neovim/neovim /tmp/neovim
WORKDIR /tmp/neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && make install && rm -r /tmp/neovim

# Set correct locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales

RUN apt-get update \
&& apt-get install --no-install-recommends -y \
fzf \
fd-find \
ripgrep \
python3-pip \
sshfs \
npm \
&& npm i -g \
prettier \
@fsouza/prettierd \
rustywind \
eslint \
eslint_d \
bash-language-server \
dockerfile-language-server-nodejs \
yaml-language-server \
typescript \
typescript-language-server \
vscode-langservers-extracted \
&& rm -rf /var/lib/apt/lists/* \
&& ln -s "$(which fdfind)" /usr/bin/fd

# install lazygit
ENV LAZYGIT_VERSION="0.36.0"
RUN curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
RUN tar xf lazygit.tar.gz lazygit
RUN install lazygit /usr/local/bin

# install go 
RUN wget https://go.dev/dl/go1.19.5.linux-arm64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.5.linux-arm64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"
RUN go version

RUN go install golang.org/x/tools/gopls@latest
RUN go install github.com/jesseduffield/lazydocker@latest

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >> ./rustup-init.sh
RUN chmod +x rustup-init.sh
RUN ./rustup-init.sh -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install stylua

# Add user 'nvim' and allow passwordless sudo
RUN adduser --disabled-password --gecos '' nvim \
&& adduser nvim sudo \
&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER nvim
WORKDIR /home/nvim

ENV PATH=$PATH:/usr/local/bin/go/bin/:/home/nvim/.local/bin:/home/nvim/.local/bin/bin:/home/nvim/.cargo/bin
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN pip3 install --no-cache-dir --user pyright pynvim black

# Copy Neovim config into the image
RUN mkdir -p .config/nvim/lua
COPY --chown=nvim:nvim lua .config/nvim/lua
COPY --chown=nvim:nvim init.lua .config/nvim/init.lua

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN nvim -c 'sleep 60' -c 'qa'

ENTRYPOINT ["/bin/bash", "-c", "nvim"]
