class Transaction < ApplicationRecord
  belongs_to :merchant, class_name: 'Merchant'
  enum :status, { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :uuid, :status, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ }
  validates :amount, numericality: { greater_than: 0 }, unless: :is_reversed?
  validates :amount, absence: true, if: :is_reversed?

  scope :authorized, -> { where(type: 'AuthorizeTransaction') }
  scope :charged, -> { where(type: 'ChargeTransaction') }
  scope :refunded, -> { where(type: 'RefundTransaction') }
  scope :reversed, -> { where(type: 'ReversalTransaction') }

  after_initialize :set_uuid

  def is_authorized?
    type == 'AuthorizeTransaction'
  end

  def is_charged?
    type == 'ChargeTransaction'
  end

  def is_refunded?
    type == 'RefundTransaction'
  end

  def is_reversed?
    type == 'ReversalTransaction'
  end

  def is_charged_and_approved?
    is_charged? && approved?
  end

  def is_authorized_and_approved?
    is_authorized? && approved?
  end

  def can_be_referenced?
    approved? || refunded?
  end

  private

    def set_uuid
      self.uuid = SecureRandom.uuid
    end
end
