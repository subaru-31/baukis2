class Admin::Authenticator
  def initialize(administorator)
    @administorator = administorator
  end

  def authenticate(raw_password)
    @administorator &&
    @administorator.hashed_password &&
    BCrypt::Password.new(@administorator.hashed_password) == raw_password
  end
end