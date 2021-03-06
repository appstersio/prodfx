require 'spec_helper'

describe 'etcd get' do
  after(:each) do
    run 'krates etcd rm --recursive --force /e2e'
  end

  it 'fetches value of a key' do
    run 'krates etcd set /e2e/test yes'
    k = run! 'krates etcd get /e2e/test'
    expect(k.out.strip).to eq('yes')
  end

  it 'returns an error if key does not exist' do
    k = run 'krates etcd get /e2e/foobar'
    expect(k.code).not_to eq(0)
    expect(k.out.match(/key not found/i)).to be_truthy
  end
end
