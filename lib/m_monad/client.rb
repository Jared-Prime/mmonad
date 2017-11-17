# frozen_string_literal: true

module MMonad
  module Client
    def self.extended(base_class)
      base_class.extend MMonad::Client::Macros
    end

    module Macros
      # @params address [String] describes the socket,
      #   including protocol and networking port, if applicable
      def endpoint(address)
        @endpoint = address
      end

      # @params interface [Symbol] describes the 0MQ wrapper
      #   interface for connecting to the socket address. Only wrappers
      #   for explicitly supported 0MQ patterns are accepted.
      # @raises MMonad::PatternNotAllowed
      def pattern(interface)
        @pattern = MMonad::Pattern.find_client(interface)
      end

      # @params response [Proc] provides the DSL hook for
      #   extending classes to define the message response
      #   processing behavior
      # @returns [Hash]
      def response(&handling)
        @response = handling
      end

      # @params seconds [Integer] provides the maximum number of
      #   seconds a client should wait for data from the socket
      def timeout(seconds = 5)
        @timeout = seconds
      end

      # @params data [Hash] provides the caller a method to send
      #   data into the 0MQ socket and receive a parsed response
      #   as defined by the `pattern` Proc provided above. The
      #   expectation is that the `pattern` finalizes as a Hash.
      # @returns [Hash]
      def message(data)
        Timeout.timeout(@timeout) do
          interaction = @pattern.new(@endpoint)
          interaction << data.to_json
          unwrap(interaction.receive)
        end
      end
      alias << message

      private

      def unwrap(resp)
        raw = JSON.parse(resp.to_a.first)

        @response.call(raw)
      end
    end
  end
end
