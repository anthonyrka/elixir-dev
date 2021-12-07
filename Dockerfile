FROM erlang:24-slim

USER root

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
        vim \
        git

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.13.0" \
	LANG=C.UTF-8

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle 

ENV GIT_SSL_NO_VERIFY=1

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="0ed0fb89a9b6428cd1537b7f9aab1d6ea64e0c5972589eeb46dff6f0324468ae" \
	&& buildDeps=' \
		ca-certificates \
		curl \
		make \
                git \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
        && curl -LSso /root/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim \
        && git clone https://github.com/elixir-editors/vim-elixir.git ~/.vim/bundle/vim-elixir \
        && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean \
	&& find /usr/local/src/elixir/ -type f -not -regex "/usr/local/src/elixir/lib/[^\/]*/lib.*" -exec rm -rf {} + \
	&& find /usr/local/src/elixir/ -type d -depth -empty -delete \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/*

COPY test.vimrc /root/.vimrc
WORKDIR root

CMD ["iex"]
