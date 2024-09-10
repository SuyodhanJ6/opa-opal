package ors

default allow = false

# Allow access based on attributes
allow {
  input.user.role == "admin"
}

allow {
  input.user.role == "user"
  input.payload.resource == "resource1"
  input.payload.action == "read"
}

allow {
  input.user.role == "user"
  input.payload.resource == "resource3"
  input.payload.action == "write"
}
