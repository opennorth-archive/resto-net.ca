# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
RestoNet::Application.config.secret_token = ENV['SECRET_TOKEN'] || '839c07854b2d1088caa171e928bb322309e26893fd836fe2fe13c7883884f6a0092ba77f14780322ac1adc174f298198cd8788967d9f5877972e98ae6a8b6d1b'
