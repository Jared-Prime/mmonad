# frozen_string_literal: true

RSpec.describe MMonad::Pattern do
  subject { described_class }

  describe '.find' do
    it 'returns client patterns' do
      expect(subject.find(:request))
        .to eq CZTop::Socket::REQ
    end

    it 'returns agent patterns' do
      expect(subject.find(:reply))
        .to eq CZTop::Socket::REP
    end

    it 'errors on missing patterns' do
      expect { subject.find(:foo) }
        .to raise_error(MMonad::PatternNotAllowed)
    end
  end

  describe '.find_agent' do
    it 'returns agent patterns' do
      expect(subject.find_agent(:reply))
        .to eq CZTop::Socket::REP
    end

    it 'does not return client patterns' do
      expect { subject.find_agent(:request) }
        .to raise_error(MMonad::PatternNotAllowed)
    end
  end

  describe '.find_client' do
    it 'returns client patterns' do
      expect(subject.find_client(:request))
        .to eq CZTop::Socket::REQ
    end

    it 'does not return agent patterns' do
      expect { subject.find_client(:reply) }
        .to raise_error(MMonad::PatternNotAllowed)
    end
  end
end
