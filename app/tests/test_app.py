from app import app


def client():
    return app.test_client()


def test_home_says_hello():
    response = client().get("/")
    assert response.status_code == 200
    assert b"Hello, DevOps!" in response.data


def test_health_is_ok():
    response = client().get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_metrics_are_exposed():
    client().get("/")
    response = client().get("/metrics")
    assert b"app_requests_total" in response.data
