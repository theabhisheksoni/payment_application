require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[inactive active]) }
  end
end
