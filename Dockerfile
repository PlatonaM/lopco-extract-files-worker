FROM alpine

RUN apk --no-cache add tar bzip2 xz lzip gzip zstd lzo unzip curl

RUN mkdir data_cache

WORKDIR /usr/src/worker

COPY . .

CMD [ "./main.sh"]
