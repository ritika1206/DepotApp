class User < ApplicationRecord
  EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i

  validates :name, :email, presence: true
  validates :email, uniqueness: { message: "already exists" }, format: { with: EMAIL_REGEX }

  has_many :orders, dependent: :destroy
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  # Validates that the two passwords match in field
  has_secure_password

  ## Creating Transaction/Trigger that will rollback when last user deleted
  before_destroy :restrict_admin_deletion
  after_destroy :ensure_an_admin_remains
  before_update :restrict_admin_updation

  class Error < StandardError
  end

  private 
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Cant't delete last user"
      end
    end

    def restrict_admin_deletion
      if email.downcase == 'admin@depot.com'
        raise Error.new "Can't delete admin"
      end
    end

    def restrict_admin_updation
      if email.downcase == 'admin@depot.com'
        raise Error.new "Can't update admin"
      end
    end
end
