require "openssl"

module Armor
  # Syntactic sugar for the underlying mathematical definition of PBKDF2.
  #
  # This function does not allow passing in of a dkLen (in other words
  # does not allow truncation of the final derived key).
  #
  # Returns: Binary representation of the derived key (DK).
  #
  # The default value for iter is set to 5000, and it can be
  # configured via `ENV['ARMOR_ITER']`.
  #
  # The default value for hash is "sha512", and it can also be
  # configured via `ENV['ARMOR_HASH']`.
  def self.digest(password, salt)
    iter = ENV["ARMOR_ITER"] || 5000
    hash = ENV["ARMOR_HASH"] || "sha512"

    digest = OpenSSL::Digest::Digest.new(hash)
    length = digest.digest_length

    hex(pbkdf2(digest, password, salt, Integer(iter), length))
  end

  def self.randomize(digest, password, seed)
    OpenSSL::HMAC.digest(digest, password, seed)
  end

  # Binary to hex convenience method.
  def self.hex(str)
    str.unpack("H*").first
  end

  # The PBKDF2 key derivation function has five input parameters:
  #
  #     DK = PBKDF2(PRF, Password, Salt, c, dkLen)
  #
  # where:
  #
  # - PRF is a pseudorandom function of two parameters
  # - Password is the master password from which a derived key is generated
  # - Salt is a cryptographic salt
  # - c is the number of iterations desired
  # - dkLen is the desired length of the derived key
  #
  #   DK is the generated derived key.
  #
  def self.pbkdf2(digest, password, salt, c, dk_len)
    blocks_needed = (dk_len.to_f / digest.size).ceil

    result = ""

    # main block-calculating loop:
    1.upto(blocks_needed) do |n|
      result << concatenate(digest, password, salt, c, n)
    end

    # truncate to desired length:
    result.slice(0, dk_len)
  end

  # The function F is the xor (^) of c iterations of chained PRFs.
  # The first iteration of PRF uses Password as the PRF key and Salt
  # concatenated to i encoded as a big-endian 32-bit integer.
  #
  # Note that i is a 1-based index. Subsequent iterations of PRF use
  # Password as the PRF key and the output of the previous PRF
  # computation as the salt:
  #
  # Definition:
  #
  #     F(Password, Salt, Iterations, i) = U1 ^ U2 ^ ... ^ Uc
  #
  def self.concatenate(digest, password, salt, iterations, i)

    # U1 -> password, salt and 1 encoded as big-endian 32-bit integer.
    u = randomize(digest, password, salt + [i].pack("N"))

    ret = u

    # U2 through Uc:
    2.upto(iterations) do

      # calculate Un
      u = randomize(digest, password, u)

      # xor it with the previous results
      ret = xor(ret, u)
    end

    ret
  end

private
  def self.xor(a, b)
    result = "".encode("ASCII-8BIT")

    b_bytes = b.bytes.to_a

    a.bytes.each_with_index do |c, i|
      result << (c ^ b_bytes[i])
    end

    result
  end
end
