# Stage 1: Build Stage
FROM python:3.13.3-alpine as builder

# Install necessary build tools and clean up afterward
RUN apk add --no-cache gcc musl-dev libffi-dev

# Set working directory
WORKDIR /app

# Copy dependency definitions
COPY requirements.txt .

# Install dependencies to a temporary directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Runtime Stage
FROM python:3.13.3-alpine

# Copy only necessary runtime files from the builder stage
COPY --from=builder /install /usr/local
WORKDIR /app

# Copy application code
COPY . .

# Expose the application port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py

# Command to initialize the database and start the application
CMD ["sh", "-c", "python3 init_db.py && gunicorn -w 4 -b 0.0.0.0:5000 app:app"]
