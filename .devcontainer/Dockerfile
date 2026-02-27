# SDK compatible con Zephyr v4.1.0 → v0.16.8
# Para otras versiones: https://github.com/zephyrproject-rtos/sdk-ng/releases
ARG ZEPHYR_SDK_TAG=main
FROM zephyrprojectrtos/zephyr-build:${ZEPHYR_SDK_TAG}

# La imagen base corre como usuario no-root; necesitamos root para apt-get
USER root

# Shell usable: bash + autocompletado + herramientas de debug serie
RUN apt-get update -q && apt-get install -y --no-install-recommends \
        bash-completion \
        curl \
        minicom \
        picocom \
    && rm -rf /var/lib/apt/lists/* \
    && echo "source /etc/bash_completion" >> /etc/bash.bashrc

# udevadm stub – en contenedores no existe el daemon udev; el post-install de jlink
# lo llama y falla sin él. Este stub lo convierte en no-op durante el build.
RUN printf '#!/bin/sh\nexit 0\n' > /usr/local/bin/udevadm && chmod +x /usr/local/bin/udevadm

# SEGGER J-Link – requerido por nrfutil device y nrfjprog para flashear vía J-Link
# SEGGER exige aceptar la licencia al descargar; se hace vía POST.
# Versión testeada por nrfutil: JLink_V8.76  →  sufijo del archivo: V876
RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
        libxcb-render-util0 libxcb-shape0 libxkbcommon-x11-0 \
    && curl -fsSL \
        --data "accept_license_agreement=accepted&non_emb_ctr=confirmed&submit=Download+software" \
        -o /tmp/jlink.deb \
        "https://www.segger.com/downloads/jlink/JLink_Linux_V876_x86_64.deb" \
    && dpkg -i /tmp/jlink.deb || true \
    && rm /tmp/jlink.deb \
    && rm -rf /var/lib/apt/lists/*

# nrfutil – binario principal en /usr/local/bin (accesible para todos los usuarios)
# URL from: https://docs.nordicsemi.com/bundle/nrfutil/page/guides/installing.html
RUN curl -fL https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil \
    -o /usr/local/bin/nrfutil \
    && chmod +x /usr/local/bin/nrfutil

# Volver al usuario original de la imagen
USER user

# Instalar el subcomando 'device' de nrfutil (se guarda en ~/.nrfutil del usuario)
RUN nrfutil install completion
RUN nrfutil install device

WORKDIR /workspaces
SHELL ["/bin/bash", "-c"]