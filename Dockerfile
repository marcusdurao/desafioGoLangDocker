FROM golang:latest as builder

RUN apt-get update && \
    apt-get install upx -y

WORKDIR /usr/src/app/bin
COPY src/ .

#RUN  GOOS=linux \
#  go build -ldflags="-s -w" teste.go && \
#  upx --brute  teste

RUN CGO_ENABLED=0 GOOS=linux \
  go build -a -ldflags '-extldflags "-static" -s -w' teste.go && \
  upx --brute teste

RUN rm /usr/src/app/bin/teste.go

FROM scratch
WORKDIR /var/src/app/bin
COPY --from=builder /usr/src/app/bin .

CMD ["./teste"]