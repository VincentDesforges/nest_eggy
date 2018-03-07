require 'api_calls'
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :bank_accounts, dependent: :destroy
  has_many :transactions, through: :bank_accounts
  after_create :call_api

  protected

  def call_api
    user_details = { email: self.email, password: self.encrypted_password }
    ApiCalls::RequestMethods.create_user(user_details)
  end
end
