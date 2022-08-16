class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # Validates that the two passwords match in field
  has_secure_password

  ## Creating Transaction/Trigger that will rollback when last user deleted
  after_destroy :ensure_an_admin_remains

  class Error < StandardError
  end

  private def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Cant't delete last user"
    end
  end
end