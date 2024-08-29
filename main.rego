package ors

import future.keywords

default allow := false

# Allow access if the user is an admin
allow {
    input.user.role == "admin"
}

# Allow access for regular users if specific conditions are met
allow {
    input.user.role != "admin"
    valid_coordinates
    valid_preference
    valid_alternative_routes
}

valid_coordinates {
    # Check that all coordinates satisfy the conditions
    count(input.payload.coordinates) == count([coord |
        coord := input.payload.coordinates[_]
        coord[0] > 78.0  # Longitude condition
        coord[1] > 25.0  # Latitude condition
    ])
}

valid_preference {
    input.payload.preference == "fastest"
}

valid_alternative_routes {
    input.payload.alternative_routes.target_count <= 10
    input.payload.alternative_routes.weight_factor <= 2.0
    input.payload.alternative_routes.share_factor <= 1.0
}

# Check if the request matches the allowed API endpoint
allow {
    input.method == "POST"
    input.path == data.api_endpoint
}

