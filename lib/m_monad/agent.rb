# frozen_string_literal: true

module MMonad
  module Agent
    def self.extended(base_class)
      base_class.extend MMonad::Agent::Macros
    end

    # class level methods implementing the Agent DSL
    module Macros
      # @params address [String] describes the socket,
      #   including the protocol and networking port, if applicable
      def socket(address)
        @socket = address
      end

      # @params pattern [Symbol] describes the 0MQ wrapper
      #   interface for binding to the socket address. Only wrappers
      #   for explicitly supported 0MQ patterns are accepted.
      # @raises MMonad::PatternNotAllowed
      def pattern(interface)
        @pattern = MMonad::Pattern.find_agent(interface)
      end

      # @params procedure [Proc] provides the DSL hook for
      #   extending classes to define the message processing loop
      def process(&handling)
        @process = handling
      end

      # @params handling [Proc] provides the DSL hook for
      #   extending classes to define the error handling behavior
      def exceptions(&handling)
        @exceptions = handling
      end

      # The `run` class method binds to the specified socket
      # and begins the processing loop. Once called, `run` will
      # block indefinitely. `run` should only be called once and
      # is intended to be thread-safe.
      def run
        active_socket = @pattern.new(@socket)

        while message = active_socket.receive
          active_socket << process!(message).to_json
        end
      end

      private

      def unwrap(message)
        JSON.parse(message.to_a.first)
      end

      def process!(message)
        @process.call(unwrap(message))
      rescue => exception
        if !defined?(@exceptions)
          unhandled(exception)
        else
          @exceptions.call(exception) || unhandled(exception)
        end
      end

      def unhandled(exception)
        { unhandled_exception: exception }
      end
    end
  end
end
