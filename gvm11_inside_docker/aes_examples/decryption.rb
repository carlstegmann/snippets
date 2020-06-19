#!/usr/bin/env ruby

#####################################################################
# Do not use in production, this is for educationally purpose only! #
#####################################################################

# see the ruby documentation for details
# https://docs.ruby-lang.org/en/master/OpenSSL/Cipher.html#class-OpenSSL::Cipher-label-Authenticated+Encryption+and+Associated+Data+-28AEAD-29

require 'openssl'

encrypted_file = File.open('encrypted_message', 'rb')
encrypted = encrypted_file.read.strip
key_file = File.open('my_secret.key', 'rb')
key = key_file.read.strip
iv_file = File.open('my_iv', 'rb')
iv = iv_file.read.strip
my_auth_data_file = File.open('my_auth_data', 'rb')
auth_data = my_auth_data_file.read.strip
my_auth_tag_file = File.open('my_auth_tag', 'rb')
auth_tag = my_auth_tag_file.read.strip
raise "tag is truncated!" unless auth_tag.bytesize == 16

puts "Encrypted message content:"
puts encrypted
puts "Key used to encrypt / decrypt:"
puts key
puts "Used nonce / iv you name it:"
puts iv
puts "Auth data:"
puts auth_data
puts "Auth tag:"
puts auth_tag

decipher = OpenSSL::Cipher::AES.new(256, :GCM).decrypt
decipher.key = key
decipher.iv = iv
decipher.auth_tag = auth_tag
decipher.auth_data = auth_data

plain = decipher.update(encrypted) + decipher.final

puts plain
