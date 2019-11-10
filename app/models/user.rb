class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def tgvmax_key_valid?
    tgvmax_key.match(/^HC[0-9]{9}$/)
  end
end
