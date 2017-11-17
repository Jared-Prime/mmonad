# frozen_string_literal: true

RSpec.describe MMonad::Agent do
  subject do
    class TestAgent
      extend MMonad::Agent
    end
  end

  describe '.socket' do
    it 'sets the socket address' do
      subject.socket 'tcp://1.2.3.4:5678'

      expect(subject.instance_variable_get(:@socket))
        .to eq 'tcp://1.2.3.4:5678'
    end
  end

  describe '.pattern' do
    it 'sets available agent patterns' do
      subject.pattern :reply

      expect(subject.instance_variable_get(:@pattern))
        .to eq CZTop::Socket::REP
    end

    it 'errors on client patterns' do
      expect { subject.pattern(:request) }
        .to raise_error MMonad::PatternNotAllowed
    end

    it 'errors on unavailable patterns' do
      expect { subject.pattern(:foo) }
        .to raise_error MMonad::PatternNotAllowed
    end
  end

  describe '.process' do
    it 'accepts a block' do
      subject.process { |_| }

      expect(subject.instance_variable_get(:@process))
        .to respond_to(:call)
    end
  end

  describe '.exceptions' do
    it 'accepts a block' do
      subject.exceptions { |_| }

      expect(subject.instance_variable_get(:@exceptions))
        .to respond_to(:call)
    end
  end
end
