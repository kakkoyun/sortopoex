FROM elixir:1.8-alpine as builder
ENV MIX_ENV=prod

RUN apk add --no-cache git

COPY . /opt/sortopoex
WORKDIR /opt/sortopoex

RUN rm -rf _build \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix clean \
  && mix deps.get --only ${MIX_ENV} \
  && mix compile \
#   && mix phx.digest \ # since there aren't any static files to serve at this stage
  && mix release --env=${MIX_ENV} --no-tar

FROM alpine:3.9 as runner
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 MIX_ENV=prod REPLACE_OS_VARS=true

COPY --from=builder /opt/sortopoex/_build/prod/rel/sortopoex /opt/sortopoex
COPY --from=builder /opt/sortopoex/container /opt/sortopoex/container

RUN apk add --no-cache bash su-exec

RUN adduser -D -g '' appuser
RUN chown -R appuser /opt/sortopoex

WORKDIR /opt/sortopoex
RUN chmod +x ./container/launch.sh

ENTRYPOINT ["./container/launch.sh"]
CMD ./bin/sortopoex foreground

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_REF_MSG
ARG VCS_URL
ARG VERSION

LABEL vendor="kakkoyun" \
  name="kakkoyun/sortopoex" \
  maintainer="kakkoyun@gmail.com" \
  description="sortopoex is a topological task sorter service" \
  com.kakkoyun.component.name="sortopoex" \
  com.kakkoyun.component.build-date="$BUILD_DATE" \
  com.kakkoyun.component.vcs-url="$VCS_URL" \
  com.kakkoyun.component.vcs-ref="$VCS_REF" \
  com.kakkoyun.component.vcs-ref-msg="$VCS_REF_MSG" \
  com.kakkoyun.component.version="$VERSION" \
  com.kakkoyun.component.distribution-scope="public" \
  com.kakkoyun.component.changelog-url="https://github.com/kakkoyun/sortopoex/releases" \
  com.kakkoyun.component.url="https://github.com/kakkoyun/sortopoex" \
  com.kakkoyun.component.run="docker run -e ENV_NAME=ENV_VALUE IMAGE" \
  com.kakkoyun.component.environment.required="MIX_ENV, SORTOPOEX_SECRET_KEY_BASE" \
  com.kakkoyun.component.environment.optional="SORTOPOEX_EXPOSED_HOST, SORTOPOEX_EXPOSED_PORT, SORTOPOEX_EXPOSED_VIA_SSL, SORTOPOEX_LOG_LEVEL" \
  com.kakkoyun.component.dockerfile="/opt/sortopoex/Dockerfile"
