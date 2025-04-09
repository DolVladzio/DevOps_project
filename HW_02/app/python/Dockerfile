FROM python:3.13.3-alpine

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENV FLASK_APP=app.py
# First run the file to initialize the database/table, 
# then run the apllication via gunicorn
CMD sh -c "python3 init_db.py && gunicorn -w 4 -b 0.0.0.0:5000 app:app"
