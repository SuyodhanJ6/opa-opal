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

valid_coordinates {
  # Check that all coordinates satisfy the conditions
  count(input.payload.coordinates) == count({ coord | 
    coord = input.payload.coordinates[_] 
    coord[0] > 91.0  # Longitude condition
    coord[1] > 25.0  # Latitude condition
  })
}
