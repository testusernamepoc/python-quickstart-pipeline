FROM python:3.7-alpine

WORKDIR /code

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8000

EXPOSE 8000

COPY . .

CMD ["flask", "run"]