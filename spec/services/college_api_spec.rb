require 'rails_helper'

describe CollegeApi do
  subject { described_class.search(school_name:) }

  describe '.search' do
    before do
      stub_request(:any, /api\.data\.gov/)
        .to_return(body: results)
    end

    context 'with a search term' do
      let(:school_name) { 'Har' }
      let(:results) do
        {
          results: [
            {
              'school.name' => "Harvey Mudd College",
              'id' => 115409,
              'location.lat' => 34.106515,
              'location.lon' => -117.709837
            }
          ]
        }.to_json
      end

      it 'fetches results' do
        expect { subject }.not_to raise_error
        expect(subject.count).not_to be_zero
      end
    end

    context 'with a term too small' do
      let(:school_name) { 'Ha' }
      let(:results) { '' }

      it 'fetches results' do
        expect { subject }.not_to raise_error
        expect(subject.count).to be_zero
      end
    end
  end
end
