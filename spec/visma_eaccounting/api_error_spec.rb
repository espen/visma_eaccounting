require 'spec_helper'

describe VismaEaccounting::APIError do
  let(:message) { 'Foo' }
  let(:params) do
    {
      title: 'error_title',
      detail: 'error_detail',
      body: 'error_body',
      raw_body: 'error_raw_body',
      status_code: 'error_status_code'
    }
  end

  before do
    @visma_eaccounting = VismaEaccounting::APIError.new(message, params)
  end

  it "adds the error params to the error message" do
    expected_message = "Foo "                               \
                       "@title=\"error_title\", "           \
                       "@detail=\"error_detail\", "         \
                       "@body=\"error_body\", "             \
                       "@raw_body=\"error_raw_body\", "     \
                       "@status_code=\"error_status_code\""

    expect(@visma_eaccounting.message).to eq(expected_message)
  end

  it 'sets the title attribute' do
    expect(@visma_eaccounting.title).to eq(params[:title])
  end

  it 'sets the detail attribute' do
    expect(@visma_eaccounting.detail).to eq(params[:detail])
  end

  it 'sets the body attribute' do
    expect(@visma_eaccounting.body).to eq(params[:body])
  end

  it 'sets the raw_body attribute' do
    expect(@visma_eaccounting.raw_body).to eq(params[:raw_body])
  end

  it 'sets the status_code attribute' do
    expect(@visma_eaccounting.status_code).to eq(params[:status_code])
  end
end
