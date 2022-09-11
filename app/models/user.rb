class User < ApplicationRecord
  EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i

  validates :name, :email, presence: true
  validates :email, uniqueness: { message: "already exists" }, format: { with: EMAIL_REGEX }

  # Validates that the two passwords match in field
  has_secure_password

  ## Creating Transaction/Trigger that will rollback when last user deleted
  before_destroy :restrict_admin
  after_destroy :ensure_an_admin_remains
  before_update :restrict_admin
  after_save :send_welcome_email, only: :create

  class Error < StandardError
  end

  private 
    def ensure_an_admin_remains
      if User.count.zero?
        throw Error.new "Cant't delete last user"
      end
    end

    def restrict_admin
      if email.downcase == SENDER_EMAIL
        throw Error.new "Action restricted for admin"
      end
    end

    def send_welcome_email
      UserMailer.with(user: self).welcome_email(params[:user]).deliver_later
    end
end
