# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Myidea::Application.initialize!

# Application Constant
IDEA_STATUS_UNDER_REVIEW = 0
IDEA_STATUS_REVIEWED_FAIL = 1
IDEA_STATUS_REVIEWED_OK = 2
IDEA_STATUS_IN_THE_WORKS = 3
IDEA_STATUS_LAUNCHED = 4
IDEA_SORT_HOT = 0
IDEA_SORT_NEW = 1
IDEA_SORT_POINTS = 2
IDEA_SORT_COMMENTS = 3
ACTIVITY_CREATE_IDEA = 'create'
ACTIVITY_COMMENT_IDEA = 'comment'
ACTIVITY_LIKE_IDEA = 'like'
ACTIVITY_UNLIKE_IDEA = 'unlike'
ACTIVITY_FAVORITE_IDEA = 'favorite'
ACTIVITY_UNFAVORITE_IDEA = 'unfavorite'
PREFERENCE_SITE_NAME = 'site_name'
