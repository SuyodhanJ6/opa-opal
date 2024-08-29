package ors

import future.keywords
import data.microservices

default allow := false
default valid_coordinates := false

# Allow access if the user is an admin
allow {
    input.user.role == "admin"
}

# Allow access for regular users if specific conditions are met
allow {
    input.user.role == "user"
    valid_coordinates
    valid_preference
}

# Check if coordinates are valid (between 80 and 82 for users)
valid_coordinates {
    input.user.role == "user"
    count(input.payload.coordinates) == count([coord |
        coord := input.payload.coordinates[_]
        coord[0] >= 80
        coord[0] <= 82
    ])
}

# Admins bypass coordinate check
valid_coordinates {
    input.user.role == "admin"
}

valid_preference {
    input.payload.preference == "fastest"
}

# Function to get the microservice URL
microservice_url := microservices.ors.url {
    input.path == microservices.ors.path
}

# Main decision rule
response := {
    "allow": allow,
    "valid_coordinates": valid_coordinates,
    "response": http.send({
        "method": "POST",
        "url": microservice_url,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.marshal(input.payload),
    })
}
