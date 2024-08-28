package httpapi.authz

default allow = false

allow {
    input.method == "GET"
    input.path == ["health"]
}

allow {
    input.method == "POST"
    input.path = ["or", "v2", "directions", "foot-walking"]
}

allow {
    input.method == "PUT"
    startswith(input.path[0], "v1/policies")
}

allow {
    input.method == "GET"
    input.path = ["v1", "policies"]
}
