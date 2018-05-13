class ShareForm
  include ActiveModel::Model
  attr_accessor :email, :message
  validates :email,
            presence: { message: "Email can't be blank" },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Invalid Email format' }
end
