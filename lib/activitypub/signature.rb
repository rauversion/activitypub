# frozen_string_literal: true

require "openssl"

# Digital signatures are essential in federated networks
# like ActivityPub to ensure data integrity and authenticity.
# A commonly used algorithm for generating these signatures
# in the ActivityPub community is the RSA-SHA256 algorithm.

module ActivityPub
  # This class handles the generation and verification of ActivityPub signatures.
  # It ensures that outgoing messages are authenticated and incoming messages
  # are verified against a known public key.
  class Signature
    # Generates a new RSA private and public key pair
    def self.generate_keypair
      key = OpenSSL::PKey::RSA.new(2048)
      { private: key.to_pem, public: key.public_key.to_pem }
    end

    # Signs data with the given private key
    def self.sign(data, private_key_pem)
      private_key = OpenSSL::PKey::RSA.new(private_key_pem)
      signature = private_key.sign(OpenSSL::Digest::SHA256.new, data)
      Base64.encode64(signature).gsub("\n", "")
    end

    # Verifies the signature with the provided public key
    def self.verify?(data, signature, public_key_pem)
      public_key = OpenSSL::PKey::RSA.new(public_key_pem)
      signature_decoded = Base64.decode64(signature)
      public_key.verify(OpenSSL::Digest::SHA256.new, signature_decoded, data)
    end
  end
end
