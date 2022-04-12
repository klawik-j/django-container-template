FROM python:3.8

ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code

COPY requirements.txt requirements.txt

RUN apt-get update &&\
    apt-get install ffmpeg libsm6 libxext6  -y &&\
    pip install --upgrade pip &&\
    pip install -r requirements.txt

COPY ./code/ /code/

ENTRYPOINT ["bash", "docker-entrypoint.sh"]
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8080"]
