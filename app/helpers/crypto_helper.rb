require 'openssl'

module CryptoHelper

  def self.encrypt(string)
    cipher = OpenSSL::Cipher::Cipher.new("aes-128-cbc")
    cipher.encrypt
    cipher.padding = 1
    cipher.key = hex_to_bin(Digest::SHA1.hexdigest(ENV['CRYPT_KEEPER_SECRET_KEY'])[0..32])
    cipher_text = cipher.update(string)
    cipher_text << cipher.final
    return bin_to_hex(cipher_text).upcase
  end

  def self.decrypt(encrypted)
    encrypted = hex_to_bin(encrypted.downcase)
    cipher = OpenSSL::Cipher::Cipher.new("aes-128-cbc")
    cipher.decrypt
    cipher.padding = 1
    cipher.key = hex_to_bin(Digest::SHA1.hexdigest(ENV['CRYPT_KEEPER_SECRET_KEY'])[0..32])
    d = cipher.update(encrypted)
    d << cipher.final
  end

  def self.hex_to_bin(str)
    [str].pack "H*"
  end

  def self.bin_to_hex(s)
    s.unpack('C*').map{ |b| "%02X" % b }.join('')
  end
end
