FROM python:3.9-alpine
RUN apk add --no-cache git
RUN pip install --upgrade pip

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt
RUN apk --no-cache add curl

RUN chmod +x ./entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]