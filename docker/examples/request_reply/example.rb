#!/usr/bin/env ruby
# frozen_string_literal: true

require 'm_monad'

class MyAgent
  extend MMonad::Agent

  socket 'tcp://0.0.0.0:5678'
  pattern :reply

  process do |message|
    puts "got a message: #{message}"

    { business_reply: 'Business is great!' }
  end

  exceptions do |exception|
    { business_reply: "This is not good for business: #{exception}" }
  end
end

class MyClient
  extend MMonad::Client

  endpoint 'tcp://localhost:5678'
  pattern :request

  timeout 5 # seconds

  response do |message|
    puts "got a response: #{message}"
  end
end

Thread.new { MyAgent.run }

MyClient << { customer_message: 'How is business?' }
