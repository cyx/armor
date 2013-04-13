Armor
=====

[Shield][shield]'s partner in crime.

[shield]: http://cyx.github.io/shield/

Description
-----------

Armor is a pure Ruby implementation of [PBKDF2][pbkdf2], a
password-based key derivation function recommended for the
protection of electronically-stored data.

[pbkdf2]: http://en.wikipedia.org/wiki/PBKDF2

Basic Use
---------

Simply pass in the password and salt, and you'll get
the derived key, i.e.

```ruby
result = Armor.digest("password1", "salt")

# You can now store this in your database, together with your salt.
User.create(email: "foo@bar.com", crypted_password: result, salt: "salt")

# Or you can do it shield style and compress the password into one
# field by utilizing a constant length salt, e.g.
salt = SecureRandom.hex(32) # 64 characters
result = Armor.digest("password1", salt)

User.create(email: "foo@bar.com", crypted_password: result + salt)
```

Advanced Usage
--------------

Armor comes with some very sane defaults, namely:

1.  Number of iterations:

        ENV['ARMOR_ITER'] || 5000

2.  Hashing function to be used:

        ENV['ARMOR_HASH'] || 'sha512'

This line will run your app in a different configuration:

```
$ ARMOR_HASH=sha1 ARMOR_ITER=50_000 rackup
```

Measuring the target slowness
-----------------------------

So the main reason for PBKDF2 is to slow down the hashing function. Normally
you would measure the desired average time delay that you want, i.e. 50ms.

For this, you can use the command line tool to quickly estimate a good
iteration value:

```
$ armor 5000
Iterations: 5000, Time: 0.12

$ armor 10000
Iterations: 10000, Time: 0.24

$ armor 20000
Iterations: 20000, Time: 0.48
```

Installation
------------

As usual, you can install it using rubygems.

```
$ gem install armor
```
