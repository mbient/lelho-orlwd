FROM gcc:latest AS builder
WORKDIR /app
COPY ./src/ .
RUN gcc -o Hello hello.c

FROM alpine:latest
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY --from=builder /app/Hello .
RUN chmod +x Hello
CMD ["./Hello"]
