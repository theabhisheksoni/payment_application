require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { build(:transaction) } 

  before { subject.save }

  it 'status should be present' do
    subject.status = nil
    expect(subject).to_not be_valid  
  end

  it 'uuid should be present' do
    subject.uuid = nil
    expect(subject).to_not be_valid  
  end

  it 'amount should be present and greator then zero' do
    subject.amount = 0.0
    expect(subject).to_not be_valid  
  end

  it 'customer_email should be formated' do
    subject.customer_email = { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/  }
    expect(subject).to_not be_valid  
  end

  it 'amount should be present and greator then zero' do
    subject.amount = 0.0
    expect(subject).to_not be_valid  
  end

  it 'Merchant should be present' do
    subject.amount = nil
    expect(subject).to_not be_valid  
  end
end
