require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /index' do
    it 'should have the content of Root Page' do
      get root_path
      expect(response).to render_template('home/index')
    end
  end
end
