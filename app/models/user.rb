class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :tgvmax_key, format: { with: /HC[0-9]{9}/, message: ' - Enter a correct TGVMAX key like HC123456789' }
  validate :validate_age

  def tgvmax_key_valid?
    tgvmax_key.match(/^HC[0-9]{9}$/)
  end

  private

  def validate_age
    return if birthdate.present? && birthdate < 16.years.ago && birthdate > 28.years.ago

    errors.add(:birthdate, ': You should be between 16 and 27 years old')
  end
end
