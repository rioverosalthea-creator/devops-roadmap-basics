# 1. Start from a small official Python image
FROM python:3.12-slim

# 2. Work inside /app in the container
WORKDIR /app

# 3. Install dependencies first (Docker caches this layer)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy the application code
COPY . .

# 5. Document the port and start the app with a production web server
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
