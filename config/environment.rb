# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Myidea::Application.initialize!

# Application Constant
IDEA_STATUS_UNDER_REVIEW = 'under_review'
IDEA_STATUS_REVIEWED_FAIL = 'reviewed_fail'
IDEA_STATUS_REVIEWED_SUCCESS = 'reviewed_success'
IDEA_STATUS_IN_THE_WORKS = 'in_the_works'
IDEA_STATUS_LAUNCHED = 'launched'
IDEA_FAIL_REPEATED = 'repeated'
IDEA_FAIL_LAUNCHED = 'launched'
IDEA_FAIL_INVALID = 'invalid'
PREFERENCE_SITE_NAME = 'site_name'
