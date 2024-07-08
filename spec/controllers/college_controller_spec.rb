require 'rails_helper'

describe CollegeController do
  describe '#index' do
    subject do
      get :index, params: { school_name: }
      response
    end

    before { allow(CollegeApi).to receive(:search).with(school_name: 'Har').and_return(results) }

    context 'with a search param' do
      let(:school_name) { 'Har' }
      let(:results) do
        [
          {
            'school.name' => "Harvey Mudd College",
            'id' => 115409,
            'location.lat' => 34.106515,
            'location.lon' => -117.709837
          }
        ]
      end

      it 'fetches results' do
        expect { subject }.not_to raise_error
        expect(subject).to have_http_status(:ok)
        expect(CollegeApi).to have_received(:search)
      end
    end
  end
end
