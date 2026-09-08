FROM balenalib/raspberrypi4-64:bookworm

RUN apt-get update && apt-get install -y \
    weston \
    libgbm1 \
    libdrm2 \
    libwayland-client0 \
    libwayland-server0 \
    libegl1-mesa \
    libgles2-mesa \
    && rm -rf /var/lib/apt/lists/*

ENV GBM_BACKEND=vc4-drm
ENV EGL_PLATFORM=drm
ENV DISPLAY=:0

CMD ["weston", "--backend=drm-backend.so", "--tty=1"]