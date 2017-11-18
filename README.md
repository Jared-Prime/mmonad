[![Gem Version](https://badge.fury.io/rb/mmonad.svg)](https://badge.fury.io/rb/mmonad)
[![CircleCI](https://circleci.com/gh/Jared-Prime/mmonad.svg?style=svg)](https://circleci.com/gh/Jared-Prime/mmonad)

# MMonad

Messaging Monad, backed by 0MQ

## Purpose

`MMonad` provides a DSL for sending and receiving messages through 0MQ sockets.

## Installation Requirements

1. 0MQ
  - `libzmq` ZeroMQ core engine in C++, implements ZMTP/3.0 https://github.com/zeromq/libzmq
  - `czmq` High-level C binding for ØMQ https://github.com/zeromq/czmq
2. Ruby
  - `2.4.2` minimum supported. [`rbenv` is the recommended Ruby install tool](https://github.com/rbenv/rbenv#installation)
3. Docker https://store.docker.com/search?offering=community&type=edition (optional, but highly recommended)

Users with a Docker installation will find the first two requirements met by using the published image layer at https://hub.docker.com/r/jprime/mmonad

## Contributions & Licensing

User contributions are welcome and subject to the [CONTRIBUTING](https://github.com/Jared-Prime/mmonad/blob/master/CONTRIBUTING) guide. All code made available under [AGPL-3.0](https://github.com/Jared-Prime/mmonad/blob/master/LICENSE).

## Project Specifications

`MMonad` makes two interfaces available to Ruby programmers: (1) the `MMonad::Agent` and (2) the `MMonad::Client`. These interfaces are provided as modules. Users `extend` a class with the chosen interface, supplying specific behaviors via the DSL.

DSL for _data-processing_ nodes:

- `MMonad::Agent`
  - `.socket` specifies underlying socket or address for networking
  - `.pattern` specifies the 0MQ socket pattern for message delivery
  - `.process` specifies the programmer's steps for message ingestion and/or transformation
  - `.exceptions` specifies the programmer's custom error handling behavior
  - `.run` initiates the data-processing loop with the above DSL specifications, blocking on the thread

DSL for _data-passing_ nodes:

- `MMonad::Client`
  - `.endpoint` specifies the underlying socket or address for networking
  - `.pattern` specifies the 0MQ socket pattern for message passing
  - `.response` specifies the programmer's steps for response parsing
  - `.timeout` specifies how long to wait on a socket for a response
  - `.message` accepts a Hash to pass along the 0MQ socket as data

## Examples

Each example below has a corresponding feature test. See the feature test directory for basic testing strategies. See the `MMonad::Pattern::LIBRARY` for currently supported patterns.

### Synchronous Request / Reply

```ruby
class MyAgent
  extend MMonad::Agent

  socket 'tcp://0.0.0.0:5678'
  pattern :reply

  process do |message|
    puts "got a message: #{message}"

    { my_reply: "Thank You!" }
  end

  exceptions do |exception|
    { my_reply: "This is not nice: #{exception}" }
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

MyClient << { my_request: "Here's my message" }

#=> got a message: { "my_request" => "Here's a gift" }
#=> got a response: { "my_reply" => "Thank You!" }
```