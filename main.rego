package ors

import future.keywords
import data.microservices

default allow := false
default response := null

# Allow access and return response if the user is an admin
allow {
    input.user.role == "admin"
}

response := http.send({
    "method": "POST",
    "url": microservices.routing_service,
    "body": input.payload
}) {
    input.user.role == "admin"
}

# Allow access for regular users if specific conditions are met
allow {
    input.user.role == "user"
    valid_coordinates
}

# Check if coordinates are valid (between 80 and 82 longitude)
valid_coordinates {
    count(input.payload.coordinates) == count([coord |
        coord := input.payload.coordinates[_]
        coord[0] >= 80.0
        coord[0] <= 82.0
    ])
}

# Return response for valid user requests
response := http.send({
    "method": "POST",
    "url": microservices.routing_service,
    "body": input.payload
}) {
    input.user.role == "user"
    valid_coordinates
}
