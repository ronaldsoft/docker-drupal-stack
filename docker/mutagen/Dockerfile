# Use a minimal base image.
FROM alpine:latest

# Create user and group wodby
RUN set -ex; \
    addgroup -g 1000 -S www-data; \
    adduser -u 1000 -D -S -s /bin/bash -G www-data www-data;

# Copy application files
COPY --chown=www-data:www-data . /var/www/

# Run a no-op entry point and wait to host Mutagen agent processes.
ENTRYPOINT ["tail", "-f", "/dev/null"]