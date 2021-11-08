FROM python:3.9

LABEL Maintainer="Florian Thiévent"
LABEL traefik.enable="true"
LABEL traefik.http.middlewares.datahub-https-redirect.redirectscheme.scheme="https"
LABEL traefik.http.routers.datahub-secure.entrypoints="https"
LABEL traefik.http.routers.datahub-secure.rule="Host(`datahub.thievent.org`)"
LABEL traefik.http.routers.datahub-secure.service="datahub"
LABEL traefik.http.routers.datahub-secure.tls="true"
LABEL traefik.http.routers.datahub-secure.tls.certresolver="http"
LABEL traefik.http.routers.datahub.entrypoints="http"
LABEL traefik.http.routers.datahub.middlewares="datahub-https-redirect"
LABEL traefik.http.routers.datahub.rule="Host(`datahub.thievent.org`)"
LABEL traefik.http.routers.datahub.service="datahub"
LABEL traefik.http.routers.datahub.tls.certresolver="leresolver"
LABEL traefik.http.services.datahub.loadbalancer.server.port="8000"

# Set variables for project name, and where to place files in container.
ENV PROJECT=datahub
ENV CONTAINER_HOME=/opt
ENV CONTAINER_PROJECT=$CONTAINER_HOME/$PROJECT
ENV PERMANENT_CLOSED="22.01.2021 23:59:59"

# Image updates
# RUN apt-get update && apt-get upgrade

# Create application subdirectories
RUN mkdir $CONTAINER_PROJECT
WORKDIR $CONTAINER_PROJECT
RUN mkdir $CONTAINER_PROJECT/logs
RUN echo "" > $CONTAINER_PROJECT/logs/gunicorn.log
# Copy application source code to $CONTAINER_PROJECT
COPY . $CONTAINER_PROJECT

# Install Python dependencies
RUN pip install -r $CONTAINER_PROJECT/requirements.txt

# Copy and set entrypoint
WORKDIR $CONTAINER_PROJECT
COPY ./start.sh /
RUN ["chmod", "+x", "/opt/datahub/start.sh"]

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]