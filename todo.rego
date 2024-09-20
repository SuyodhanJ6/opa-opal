package todo

default allow = false

# Admin has access to add, update, delete tasks
allow {
    input.role == "admin"
}

# Normal user can only add tasks
allow {
    input.role == "user"
    input.action == "add"
}
