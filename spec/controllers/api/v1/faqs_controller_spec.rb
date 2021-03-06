require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Api::V1::FaqsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Faq. As you add validations to Faq, be sure to
  # adjust the attributes here as well.

  before do
    valid_creator = FactoryGirl.create :faq_director
    user_authorization_header valid_creator.user.auth_token
  end

  let(:valid_attributes) {
    {:question => "question", :answer => "answer", :display => 1, :priority => 2 }
  }

  let(:invalid_attributes) {
    {:question => nil, :answer => nil}
  }

  describe "GET #index" do
    it "returns a success response" do
      faq = Faq.create! valid_attributes
      get :index, params: {id: faq.id}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      faq = Faq.create! valid_attributes
      get :show, params: {id: faq.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Faq" do
        expect {
          post :create, params: {faq: valid_attributes}
        }.to change(Faq, :count).by(1)
      end

      it "renders a JSON response with the new faq" do

        post :create, params: {faq: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(api_faq_url(Faq.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new faq" do

        post :create, params: {faq: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {:question => "question2", :answer => "answer2"}
      }

      it "updates the requested faq" do
        faq = Faq.create! valid_attributes
        put :update, params: {id: faq.to_param, faq: new_attributes}
        faq.reload
        new_attributes.each_pair do |key, value|
          expect(faq[key]).to eq(value)
        end
      end

      it "renders a JSON response with the faq" do
        faq = Faq.create! valid_attributes

        put :update, params: {id: faq.to_param, faq: valid_attributes}
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the faq" do
        faq = Faq.create! valid_attributes

        put :update, params: {id: faq.to_param, faq: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    context "director tries to delete" do
      before do
        @faq = FactoryGirl.create :faq_director
        user_authorization_header @faq.user.auth_token
      end

      it "destroys the requested faq" do
        expect {
          delete :destroy, params: {id: @faq.id}
        }.to change(Faq, :count).by(-1)
      end
    end

    context "hacker tries to delete" do
      before do
        @faq = FactoryGirl.create :faq_hacker
        user_authorization_header @faq.user.auth_token
        delete :destroy, params: {id: @faq.id}
      end

      it "does not destroy the requested faq" do
        expect(json_response[:api]).to eql ["Access Denied"]
      end
    end
  end

end
