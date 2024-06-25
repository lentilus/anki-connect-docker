FROM lsiobase/kasmvnc:ubuntujammy

ARG ANKI_VERSION=23.12.1
ARG CONNECT_VERSION=24.6.17.0

# install anki and stuff
RUN \
  apt-get update && \
  apt-get install -y anki wget zstd xdg-utils libxcb-xinerama0 libxcb-cursor0 && \
  dpkg --remove anki && \
  wget https://github.com/ankitects/anki/releases/download/${ANKI_VERSION}/anki-${ANKI_VERSION}-linux-qt6.tar.zst && \
  tar --use-compress-program=unzstd -xvf anki-${ANKI_VERSION}-linux-qt6.tar.zst && \
  cd anki-${ANKI_VERSION}-linux-qt6 && ./install.sh &&  cd .. && \
  rm -rf anki-${ANKI_VERSION}-linux-qt6 anki-${ANKI_VERSION}-linux-qt6.tar.zst && \
  apt-get clean && \
  mkdir -p /config/.local/share && \
  ln -s /config/app/Anki  /config/.local/share/Anki  && \
  ln -s /config/app/Anki2 /config/.local/share/Anki2

# install anki connect
RUN \
  wget "https://git.foosoft.net/alex/anki-connect/archive/${CONNECT_VERSION}.tar.gz" && \
  tar -xvf "${CONNECT_VERSION}.tar.gz" && \
  mkdir -p /config/app/Anki2/addons21/AnkiConnect && \
  cp -r anki-connect/plugin/* /config/app/Anki2/addons21/AnkiConnect

# system
COPY ./root /

# anki base files
COPY ./basefiles /config/app/Anki2/

# anki connect configuration
COPY ./config.json /config/app/Anki2/addons21/AnkiConnect/config.json
