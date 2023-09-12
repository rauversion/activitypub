# spec/activitypub/signature_spec.rb

RSpec.describe ActivityPub::Signature do
  let(:keypair) { described_class.generate_keypair }
  let(:data) { "Important data that needs to be signed" }

  describe '.generate_keypair' do
    it 'generates a valid RSA key pair' do
      expect(keypair[:private]).to be_a(String)
      expect(keypair[:public]).to be_a(String)
    end
  end

  describe '.sign' do
    let(:signature) { described_class.sign(data, keypair[:private]) }

    it 'signs data using a private key' do
      expect(signature).to be_a(String)
      # Note: In a real-world scenario, you'd have more comprehensive checks
      # or perhaps try verifying the signature as a test.
    end
  end

  describe '.verify?' do
    let(:signature) { described_class.sign(data, keypair[:private]) }

    it 'verifies the signed data with the correct public key' do
      expect(described_class.verify?(data, signature, keypair[:public])).to be_truthy
    end

    it 'returns false for incorrect data' do
      expect(described_class.verify?("Tampered data", signature, keypair[:public])).to be_falsey
    end
  end
end
