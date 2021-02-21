module LikeeScraper
  # The `UserNotFoundError` exception is raised if the given user could not
  # be found. It usually means that the target username or user_id is
  # invalid.
  class UserNotFoundError < Exception
  end
end
