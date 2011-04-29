# Load the rails application
require File.expand_path('../application', __FILE__)

EMAIL_FROM = "apps@rideconnection.com"

ALL_GENDERS = [["Female", "F"], ["Male", "M"], ["Other", "O"]]

# Initialize the rails application
Wiseguide::Application.initialize!
