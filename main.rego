package example.authz

default allow = false

allow {
    input.method == "GET"
    input.path == "/data/resource"
    input.token.payload.role == "admin"
}

allow {
    input.method == "POST"
    input.path == "/data/resource"
    input.token.payload.role == "editor"
}
