FROM python:3.7.3-alpine3.10
### install python dependencies if you have some
RUN pip3 install xlrd==1.2.0
COPY ./src /app
ENTRYPOINT ["python3", "/app/app.py"]

