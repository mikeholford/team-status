class Team < ApplicationRecord
  has_secure_password :secret_key, validations: false

  has_many :team_users, dependent: :destroy
  has_many :status_updates, dependent: :destroy

  validates :uuid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :public_key, presence: true, uniqueness: true
  validates :secret_key_digest, presence: true

  before_validation :ensure_keys, on: :create

  def to_param
    uuid
  end

  private

  def ensure_keys
    self.uuid ||= SecureRandom.uuid
    self.public_key ||= generate_unique_public_key
    self.secret_key ||= SecureRandom.hex(32)
  end

  def generate_unique_public_key
    loop do
      candidate = SecureRandom.hex(16)
      break candidate unless Team.exists?(public_key: candidate)
    end
  end
end
