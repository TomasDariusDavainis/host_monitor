RSpec.describe Host do
  subject(:host) { described_class.new('http://google.com') }

  context 'when host is down' do
    before do
      allow_any_instance_of(described_class).to receive(:perform_request) do
        instance_double('Response', code: 500, message: 'Unexpected error')
      end
    end

    context '#down?' do
      it 'returns true' do
        expect(host.down?).to be_truthy
      end
    end

    context '#details' do
      it 'contains message from HTTP response' do
        expect(host.details).to include('Unexpected')
      end

      it 'contains HTTP status code' do
        expect(host.details).to include('500')
      end
    end
  end

  context 'when host is up' do
    before do
      allow_any_instance_of(described_class).to receive(:perform_request) do
        instance_double('Response', code: 200, message: 'Everything\'s fine')
      end
    end

    context '#down?' do
      it 'returns false' do
        expect(host.down?).to be_falsey
      end
    end

    context '#details' do
      it 'contains message from HTTP response' do
        expect(host.details).to include('fine')
      end

      it 'contains HTTP status code' do
        expect(host.details).to include('200')
      end
    end
  end
end
