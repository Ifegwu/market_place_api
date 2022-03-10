require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
    describe "GET #show" do
        before(:each) do
            @user = FactoryBot.create :user
            get :show, params: { id: @user.id, format: :json }
        end

        it "returns the information about a reporter on a hash" do
            user_response = JSON.parse(response.body, symbolize_names: true)
            expect(user_response[:email]).to eql @user.email
        end

        it { expect(response.status).to eql(200) }
    end

    # adding a create endpoint on the users_controller_spec.rb file.
    describe 'POST #create' do
        context 'when it is successfully created' do
            before(:each) do
                @user_attributes = FactoryBot.attributes_for :user
                post :create, params: { user: @user_attributes}, format: :json
            end

            it 'renders the json representation for the user recorde created' do
                user_response = JSON.parse(response.body, symbolize_names: true)
                expect(user_response[:email]).to eql @user_attributes[:email]
            end

            it { expect(response.response_code).to eql(201)}
        end

        context 'when is not created' do
            # email will not be included
            before(:each) do
                @invalid_user_attributes = { password: '1234567', password_confirmation: '1234567' }
                post :create, params: { user: @invalid_user_attributes }, format: :json
            end
        

            it 'renders json errors' do
                user_response = JSON.parse(response.body, symbolize_names: true)
                expect(user_response).to have_key(:errors)
            end

            it 'renders the json errors why user could not be created' do
                user_response = JSON.parse(response.body, symbolize_names: true)
                expect(user_response[:errors][:email]).to include "can't be blank"
            end

            it { expect(response.response_code).to eql(422) }
        end
    end

    # updating users
    describe "PUT/PATCH #update" do
        context "when is successfully updated" do
            before(:each) do
                @user = FactoryBot.create :user
                patch :update, params: {
                    id: @user.id,
                    user: {
                        email: "newmail@marketplace.io"
                    }
                },
                format: :json
            end

            it "renders the json represntation for the updated user" do
                user_response = JSON.parse(response.body, symbolize_names: true)
                expect(user_response[:email]).to eql("newmail@marketplace.io")
            end

            it { expect(response.response_code).to eql(200) }
        end

        context "when is not updated" do
            before(:each) do
                @user = FactoryBot.create :user
                patch :update, params: {
                    id: @user.id,
                    user: { email: "badmail.com"}
                },
                format: :json
            end

            it "renders an errors json" do
                user_response = JSON.parse(response.body, symbolize_names: true)
                expect(user_response).to have_key(:errors)
            end

            it "renders the json errors on why the user could not be updated" do
                user_response = JSON.parse(response.body, symbolize_names: true)
                expect(user_response[:errors][:email]).to include("is invalid")
            end

            it { expect(response.response_code).to eql(422)}
        end 
    end

    # delete user
    describe "DELETE #destroy" do
        before(:each) do
            @user = FactoryBot.create :user
            delete :destroy, params: { id: @user.id }, format: :json
        end

        it { expect(response.response_code).to eql(204) }
    end
end