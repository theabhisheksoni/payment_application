require 'jwt'

class JwtTokenService
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, secret_key)
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, secret_key)
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    !expired(payload)
  end

  # Default options to be encoded in the token
  def self.meta
    {
      expiration_time: 1.day.to_i
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.zone.at(payload['expiration_time']) < Time.zone.now
  end

  def self.secret_key
    Rails.application.credentials.secret_key_base
  end
end
