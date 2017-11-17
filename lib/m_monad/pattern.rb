# frozen_string_literal: true

require 'cztop'

module MMonad
  PatternNotAllowed = Class.new(RuntimeError)

  module Pattern
    AGENTS = {
      reply: CZTop::Socket::REP
    }.freeze

    CLIENTS = {
      request: CZTop::Socket::REQ
    }.freeze

    LIBRARY = {}.merge(AGENTS)
                .merge(CLIENTS)
                .freeze

    def self.find(type)
      LIBRARY.fetch(type)
    rescue KeyError => ex
      raise PatternNotAllowed, ex.message
    end

    def self.find_agent(type)
      AGENTS.fetch(type)
    rescue KeyError => ex
      raise PatternNotAllowed, ex.message
    end

    def self.find_client(type)
      CLIENTS.fetch(type)
    rescue KeyError => ex
      raise PatternNotAllowed, ex.message
    end
  end
end
