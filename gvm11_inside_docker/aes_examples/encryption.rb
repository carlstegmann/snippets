#!/usr/bin/env ruby

#####################################################################
# Do not use in production, this is for educationally purpose only! #
#####################################################################

# see the ruby documentation for details
# https://docs.ruby-lang.org/en/master/OpenSSL/Cipher.html#class-OpenSSL::Cipher-label-Authenticated+Encryption+and+Associated+Data+-28AEAD-29

require 'openssl'
require 'securerandom'

data = "This is my secret message. Can you read this message in the file on disk using a texteditor or a hexeditor?"
auth_data = SecureRandom.hex(10)

cipher = OpenSSL::Cipher::AES.new(256, :GCM).encrypt
key = SecureRandom.random_bytes(32)
iv = SecureRandom.random_bytes(12)
cipher.key = key
cipher.iv = iv
cipher.auth_data = auth_data

File.open('my_secret.key', 'w+') do |file|
  file.puts key
end
puts 'Secret key written to file.'
File.open('my_iv', 'w+') do |file|
  file.puts iv
end
puts 'IV written to file.'
File.open('my_auth_data', 'w+') do |file|
  file.puts auth_data
end
puts 'auth_data written to file.'

# now encrypt
encrypted = cipher.update(data) + cipher.final
# after encryption generate auth_tag
auth_tag = cipher.auth_tag

File.open('encrypted_message', 'w+') do |file|
  file.puts encrypted
end
puts 'encrypted message written to file.'
File.open('my_auth_tag', 'w+') do |file|
  file.puts auth_tag
end
puts 'tag written to file.'
puts 'You can run the decryptin script now. This will print you the secret data. Note that you will not find this string if you hexdump the resulting file "encrypted_message".'
puts 'Remember to keep your secret key secret! This script is only for education and not for productive use!'
