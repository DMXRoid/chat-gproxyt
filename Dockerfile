FROM python:3.11.4-slim

COPY app /app
RUN pip install -r /app/requirements.txt

CMD [ "python", "/app/chatgproxyt.py" ] 
