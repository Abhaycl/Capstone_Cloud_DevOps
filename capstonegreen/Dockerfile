# hadolint ignore=DL3006,DL3007
FROM nginx:latest

## Step 1:
# Delete the existing file.
RUN rm /usr/share/nginx/html/index.html

## Step 2:
# Copy green source code to working directory.
COPY ./index.html /usr/share/nginx/html
COPY ./background.jpg /usr/share/nginx/html