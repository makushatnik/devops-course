FROM amd64/debian:stable-slim AS build
COPY /src /
COPY requirements.txt /
ENV PORT=5000

RUN apt-get update \
  && apt-get install -y python3-pip python3-venv git upx binutils \
  && pip3 install pyinstaller patchelf-wrapper staticx \
  && pip3 install -r requirements.txt && PYTHONOPTIMIZE=1  pyinstaller --onefile main.py \
  && staticx --strip -l /lib/x86_64-linux-gnu/libgcc_s.so.1 /dist/main /dist/main-slim
#RUN chmod u+x /dist/main-slim


FROM scratch
MAINTAINER Evgeny Ageev <eageev.javaee@gmail.com>
COPY --from=build /emoji.txt /
COPY --from=build tmp /tmp
COPY --from=build /dist/main-slim /
EXPOSE $PORT
ENTRYPOINT ["/main-slim"]
