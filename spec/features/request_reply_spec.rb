# frozen_string_literal: true

RSpec.describe 'synchronous request reply' do
  subject do
    class TestAgent
      extend MMonad::Agent
      socket 'ipc://spec/test.sock'
      pattern :reply
      process do |request|
        request.fetch('data').invert
      end
      exceptions do |exception|
        case exception
        when KeyError
          { error: exception.message }
        end
      end
    end

    TestAgent
  end

  let(:client) do
    class TestClient
      extend MMonad::Client
      endpoint 'ipc://spec/test.sock'
      pattern :request
      timeout 1
      response do |reply|
        { reply_was: reply }
      end
    end

    TestClient
  end

  describe '.run' do
    before :all do
      Thread.new { subject.run }
    end

    it 'processes data sent to it' do
      expect(client.message(data: { foo: 'bar' }))
        .to include reply_was: { 'bar' => 'foo' }
    end

    it 'handles expected exceptions' do
      expect(client.message(foo: '{true'))
        .to include reply_was: { 'error' => 'key not found: "data"' }
    end

    it 'handles unexpected exceptions' do
      expect(client.message('{true'))
        .to include reply_was: { 'unhandled_exception' => "undefined method `fetch' for \"{true\":String" }
    end
  end
end
