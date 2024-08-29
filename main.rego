package ors

default allow = false

# Allow access to the microservice if user is admin or conditions are met
allow {
  input.user.role == "admin"
}

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

# Forward request to the microservice if allowed
forward_request {
  allow
  response = http.send({
    "method": data.services.directions_foot_walking.method,
    "url": data.services.directions_foot_walking.url,
    "body": input.payload,
    "headers": {
      "Content-Type": "application/json"
    }
  })
}

# Denied response if not allowed
response = {
  "status": "denied",
  "message": "You are not authorized to access this resource."
} {
  not allow
}
