### Stage 1 ###
FROM python:3.13.3-alpine AS build

WORKDIR /app

RUN apk add --no-cache build-base libffi-dev openssl-dev

COPY requirements.txt /app/
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY . .

### Stage 2 ###
FROM python:3.13.3-alpine AS prod
COPY --from=builder /install /usr/local
WORKDIR /app

COPY --from=build /app /app/

EXPOSE 5000

CMD ["sh", "-c", "python3 init_db.py && gunicorn -w 4 -b 0.0.0.0:5000 app:app"]
