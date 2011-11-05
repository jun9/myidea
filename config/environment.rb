# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Myidea::Application.initialize!

# Application Constant
IDEA_STATUS_UNDER_REVIEW = 1
IDEA_STATUS_REVIEWED = 2
IDEA_STATUS_IN_THE_WORKS = 3
IDEA_STATUS_LAUNCHED = 4
