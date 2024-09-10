package ors

default allow = false

# Allow access for admin users
allow {
  input.user.role == "admin"
}

# Allow access for regular users with specific conditions
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
