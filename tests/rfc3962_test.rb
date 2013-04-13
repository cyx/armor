require File.expand_path("../lib/armor", File.dirname(__FILE__))

# see http://www.rfc-archive.org/getrfc.php?rfc=3962
# all examples there use HMAC-SHA1

test "first test case in appendix B of RFC 3962" do
  # Iteration count = 1
  #
  # Pass phrase = "password"
  #
  # Salt = "ATHENA.MIT.EDUraeburn"
  #
  # 128-bit PBKDF2 output:
  #    cd ed b5 28 1b b2 f8 01 56 5a 11 22 b2 56 35 15
  #
  # 256-bit PBKDF2 output:
  #    cd ed b5 28 1b b2 f8 01 56 5a 11 22 b2 56 35 15
  #    0a d1 f7 a0 4b b9 f3 a3 33 ec c0 e2 e1 f7 08 37

  expected = "cd ed b5 28 1b b2 f8 01 56 5a 11 22 b2 56 35 15 0a d1 f7 a0"

  ENV["ARMOR_ITER"] = "1"
  ENV["ARMOR_HASH"] = "sha1"
  actual = Armor.digest("password", "ATHENA.MIT.EDUraeburn")

  assert_equal expected.tr(' ', ''), actual
end

test "second test case in appendix B of RFC 3962" do
  # Iteration count = 2
  # Pass phrase = "password"
  # Salt="ATHENA.MIT.EDUraeburn"
  #
  # 128-bit PBKDF2 output:
  #    01 db ee 7f 4a 9e 24 3e 98 8b 62 c7 3c da 93 5d
  #
  # 256-bit PBKDF2 output:
  #    01 db ee 7f 4a 9e 24 3e 98 8b 62 c7 3c da 93 5d
  #    a0 53 78 b9 32 44 ec 8f 48 a9 9e 61 ad 79 9d 86

  ENV["ARMOR_ITER"] = "2"
  ENV["ARMOR_HASH"] = "sha1"
  actual = Armor.digest("password", "ATHENA.MIT.EDUraeburn")

  expected =  "01 db ee 7f 4a 9e 24 3e 98 8b 62 c7 3c da 93 5d a0 53 78 b9"

  assert_equal expected.tr(' ', ''), actual
end

test "should match the third test case in appendix B of RFC 3962" do
  # Iteration count = 1200
  # Pass phrase = "password"
  # Salt = "ATHENA.MIT.EDUraeburn"
  #
  # 128-bit PBKDF2 output:
  #    5c 08 eb 61 fd f7 1e 4e 4e c3 cf 6b a1 f5 51 2b
  #
  # 256-bit PBKDF2 output:
  #    5c 08 eb 61 fd f7 1e 4e 4e c3 cf 6b a1 f5 51 2b
  #    a7 e5 2d db c5 e5 14 2f 70 8a 31 e2 e6 2b 1e 13

  digest = OpenSSL::Digest::Digest.new("sha1")

  actual = Armor.pbkdf2(digest, "password", "ATHENA.MIT.EDUraeburn", 1200, 16)

  expected = "5c 08 eb 61 fd f7 1e 4e 4e c3 cf 6b a1 f5 51 2b"
  assert_equal expected.tr(' ', ''), Armor.hex(actual)

  expected =  "5c 08 eb 61 fd f7 1e 4e 4e c3 cf 6b a1 f5 51 2b" +
              "a7 e5 2d db c5 e5 14 2f 70 8a 31 e2 e6 2b 1e 13"

  actual = Armor.pbkdf2(digest, "password", "ATHENA.MIT.EDUraeburn", 1200, 32) 

  assert_equal expected.tr(' ', ''), Armor.hex(actual)
end
