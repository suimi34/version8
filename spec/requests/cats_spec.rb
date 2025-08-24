require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /cats" do
    it "猫のリストを正常に表示すること" do
      get cats_path
      expect(response).to have_http_status(200)
    end
  end
end
