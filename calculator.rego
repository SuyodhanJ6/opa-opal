package calculator

default allow = false

# Admin has access to all operations
allow {
    input.role == "admin"
}

# Normal user has access to only basic operations (add, subtract, multiply, divide)
allow {
    input.role == "user"
    input.operation == "add"
}

allow {
    input.role == "user"
    input.operation == "subtract"
}

allow {
    input.role == "user"
    input.operation == "multiply"
}

allow {
    input.role == "user"
    input.operation == "divide"
}
