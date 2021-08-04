FROM golang:1.16 AS build
COPY . /usr/local/go/src/webserver
ENV GIN_MODE=release
ENV PORT=8080
RUN go env -w GO111MODULE=off \
  && go get github.com/gin-gonic/gin
WORKDIR /usr/local/go/src/webserver
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o webserver . \
  && chmod u+x webserver

FROM scratch
COPY --from=build /usr/local/go/src/webserver/webserver /
EXPOSE $PORT
CMD ["/webserver"]
