FROM alpine:3.16

# Set default environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="America/New_York"
ENV PYTHONUNBUFFERED=1

RUN apk update && apk add --no-cache shadow

RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:${PATH}"
WORKDIR /app
COPY --chown=user . /app


USER root

RUN apk update && apk add --no-cache bash \
  curl \
  wget \
  git \
  unzip \
  coreutils \
  gtk+2.0 \
  gdk-pixbuf \
  python3-dev \
  py3-pip \
  python3-tkinter \
  tzdata \
  xvfb \
  zlib-dev \
  build-base \
  linux-headers \
  chromium \
  chromium-chromedriver

RUN cp /usr/share/zoneinfo/$TZ /etc/localtime


USER user
COPY --chown=user . .


RUN pip install --no-cache-dir -r requirements.txt

# Make the entrypoint executable
RUN chmod +x entrypoint.sh

# Set the entrypoint to our entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

#END