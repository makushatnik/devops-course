FROM alpine

COPY . /app/

RUN apk add --no-cache python3 py3-pip \
  && pip install -r /app/requirements.txt \
  && apk --purge -v del py3-pip

EXPOSE 5000
CMD ["python3", "/app/app.py"]
