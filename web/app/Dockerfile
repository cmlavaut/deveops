FROM python:3.8

Workdir /home/app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5020

COPY . . 
CMD [ "python", "main.py"]


