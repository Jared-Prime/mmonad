# frozen_string_literal: true

RSpec.describe MMonad::Client do
  subject do
    class TestClient
      extend MMonad::Client
    end
  end

  describe '.endpoint' do
    it 'sets the socket address' do
      subject.endpoint 'tcp://1.2.3.4:5678'

      expect(subject.instance_variable_get(:@endpoint))
        .to eq 'tcp://1.2.3.4:5678'
    end
  end

  describe '.pattern' do
    it 'sets available client patterns' do
      subject.pattern :request

      expect(subject.instance_variable_get(:@pattern))
        .to eq CZTop::Socket::REQ
    end

    it 'errors on agent patterns' do
      expect { subject.pattern(:reply) }
        .to raise_error MMonad::PatternNotAllowed
    end

    it 'errors on unavailable patterns' do
      expect { subject.pattern(:foo) }
        .to raise_error MMonad::PatternNotAllowed
    end
  end

  describe '.response' do
    it 'accepts a block' do
      subject.response { |_| }

      expect(subject.instance_variable_get(:@response))
        .to respond_to(:call)
    end
  end

  describe '.timeout' do
    it 'sets the maximum amount of time to wait for a response' do
      subject.timeout 1
      expect(subject.instance_variable_get(:@timeout)).to eq 1
    end
  end

  describe '.message' do
    it 'raises timeout when expired' do
      subject.endpoint 'tcp://1.2.3.4:5678'
      subject.pattern :request
      subject.timeout 1

      expect { subject.message foo: 1 }.to raise_error(Timeout::Error)
    end
  end
end
