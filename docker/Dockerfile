FROM python:rc-alpine

ENV VIRTUAL_ENV = /opt/venv
ENV PATH = "$VIRTUAL_ENV/bin:$PATH"
COPY requirements.txt .
COPY main.py .
COPY errors.py .

RUN python3 -m venv $VIRTUAL_ENV && pip install -r requirements.txt

CMD ["python", "main.py"]

