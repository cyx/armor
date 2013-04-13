require File.expand_path("../lib/armor", File.dirname(__FILE__))

test "length assertions" do
  ENV["ARMOR_HASH"] = "sha1"
  assert_equal 40, Armor.digest("monkey", "salt").length

  ENV["ARMOR_HASH"] = "sha256"
  assert_equal 64, Armor.digest("monkey", "salt").length

  ENV["ARMOR_HASH"] = "sha512"
  assert_equal 128, Armor.digest("monkey", "salt").length
end

# The old library PBKDF2 used to have bugs related to iteration count.
#
# Let's add a regression test to make sure we never get the problem.
test "iterations" do
  ENV["ARMOR_ITER"] = "1"
  assert_equal 128, Armor.digest("monkey", "salt").length

  ENV["ARMOR_ITER"] = "2"
  assert_equal 128, Armor.digest("monkey", "salt").length

  ENV["ARMOR_ITER"] = "5000"
  assert_equal 128, Armor.digest("monkey", "salt").length
end

test "equality of identical keys" do
  a = Armor.digest("monkey", "salt")
  b = Armor.digest("monkey", "salt")

  assert_equal a, b
end
