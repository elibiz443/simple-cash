class TokenServices
  def user_token(request)
    token = request.headers["Authorization"]&.split(' ')&.last
    AuthToken.find_by(token_digest: token)
  end
end
