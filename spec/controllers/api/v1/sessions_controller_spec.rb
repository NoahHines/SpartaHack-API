require 'rails_helper'

RSpec.describe Api::V1::SessionsController do
  let(:api_key){ FactoryGirl.create(:api_key) }
  before {request.headers["HTTP_AUTHORIZATION"] = "Token token=\"#{api_key.access_token}\"" }

  describe "POST #create" do

    before(:each) do
      @user = FactoryGirl.create :user
    end

    context "and the credentials are correct" do

      before(:each) do
        post :create, params: { email: @user.email, password: "12345678" }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "and the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, params: credentials
      end

      it "returns a json with an error" do
        expect(json_response[:errors][:invalid][0]).to eql "email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, params: { id: @user.auth_token }
    end

    it { should respond_with 204 }
  end


end
