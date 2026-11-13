"""A tiny web app used throughout the DevOps Fundamentals seminar.

Endpoints
  /         greeting + visit counter
  /health   health check used by CI and Docker
  /metrics  Prometheus metrics (used in the monitoring lab)
"""
import logging
import os

from flask import Flask, Response, jsonify
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

app = Flask(__name__)
logger = logging.getLogger(__name__)

REQUESTS = Counter("app_requests_total", "Total HTTP requests", ["endpoint"])

_visits = 0  # used when Redis is not available (e.g. running without Docker Compose)


def count_visit():
    """Count a visit in Redis when REDIS_HOST is set, otherwise in memory.

    If a Redis service is configured but not reachable, keep the app serving by
    falling back to the in-memory counter instead of crashing with a 500 error.
    """
    global _visits
    redis_host = os.getenv("REDIS_HOST")
    if redis_host:
        try:
            import redis

            return int(redis.Redis(host=redis_host, port=6379).incr("visits"))
        except Exception:  # pragma: no cover - depends on external service health.
            logger.warning("Redis unavailable at %s; using in-memory counter", redis_host)

    _visits += 1
    return _visits


@app.route("/")
def home():
    REQUESTS.labels(endpoint="/").inc()
    greeting = os.getenv("GREETING", "Hello, DevOps!")
    return f"{greeting} You are visitor #{count_visit()}.\n"


@app.route("/health")
def health():
    REQUESTS.labels(endpoint="/health").inc()
    return jsonify(status="ok")


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
