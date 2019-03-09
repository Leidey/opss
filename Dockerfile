FROM python:2.7

MAINTAINER Tunahan Yediel "tunahan.yediel@gmail.com"

COPY . /app

WORKDIR /app

RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python"]

CMD ["hey.py"]
