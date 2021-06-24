FROM python:3.8-slim-buster

ENV VIRTUAL_ENV = /opt/venv
ENV PATH = "$VIRTUAL_ENV/bin:$PATH"
COPY requirements.txt .

RUN python3 -m venv $VIRTUAL_ENV && pip install -r requirements.txt

COPY main.py .
CMD ["python", "main.py"]

