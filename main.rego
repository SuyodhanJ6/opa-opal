package ors

default allow = false

# Allow access if the user is an admin
allow {
  input.user.role == "admin"
}

# Allow access for regular users if specific conditions are met
allow {
  input.user.role != "admin"
  valid_coordinates
  input.payload.preference == "fastest"
}

# Validate the coordinates
valid_coordinates {
  # Ensure that all coordinates meet the required conditions
  count(input.payload.coordinates) == count({
    coord |
    coord = input.payload.coordinates[_]
    # Check if longitude is greater than 78.0 and latitude is greater than 25.0
    coord[0] > 78.0
    coord[1] > 25.0
  })
}

