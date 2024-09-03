package ors

default allow = false

# Allow access if the user is an admin
allow {
  input.user.role == "admin"
}

# Allow access for regular users if specific conditions are met
allow {
  input.user.role != "admin"
  valid_request
}

# Check if the request has valid coordinates and matches service requirements 
valid_request {
  valid_coordinates
  input.payload.profile == data.services.directions_foot_walking.profile
  input.payload.preference == data.services.directions_foot_walking.required_preference
}

valid_coordinates {
  count(input.payload.coordinates) == count({ coord | 
    coord = input.payload.coordinates[] 
    coord[0] > 78.0  # Longitude condition
    coord[1] > 25.0  # Latitude condition
  })
}

# This rule will be triggered if the request is allowed and will make an HTTP request to the microservice
forward_request {
  allow
  response := http.send({
    "method": data.services.directions_foot_walking.method,
    "url": data.services.directions_foot_walking.url,
    "body": input.payload,
    "headers": {
      "Content-Type": "application/json"
    }
  })
  response_body := response.body
  response_body  # Ensure this returns the response body from the microservice
}

# Deny response if not allowed
response := {
  "status": "denied",
  "message": "You are not authorized to access this resource."
} {
  not allow
}
