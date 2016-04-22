require 'spec_helper'

describe Rating::RatingsController, type: :controller do
  render_views

  describe 'POST create' do
    it 'requires login' do
      post :create
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      post :create
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user) { create :reviewer }
      let!(:application) { create :application }
      let(:params) { {rating: {rateable_id: application.id, rateable_type: 'Application', diversity: 5}} }

      before { sign_in user }

      it 'creates new rating record for application' do
        expect{
          post :create, params
        }.to change{Rating.count}.by 1
      end

      it 'sets rating attribute' do
        post :create, params
        rating = Rating.last
        expect(rating.diversity).to eq '5'
        expect(rating.data['diversity']).to eq '5'
        expect(rating.data[:diversity]).to eq '5'
      end

      it 'redirect_to rating/todos' do
        post :create, params
        expect(response).to redirect_to rating_todos_path
      end
    end
  end
  describe 'PUT update' do
    let(:user) { create :reviewer }
    let!(:application) { create :application }

    context 'when reviewer' do
      before { sign_in user }

      context 'when user not author of rating' do
        let!(:rating) { create :rating, :for_application, user: create(:user), rateable: application }
        let(:params) { {id: rating, rating: { diversity: 5 }} }

        it 'raises RecordNotFound exception' do
          expect{
            put :update, params
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
      context 'when user author of rating' do
        let!(:rating) { create :rating, :for_application, user: user, rateable: application }
        let(:params) { {id: rating, rating: { diversity: 5 }} }

        it 'updates rating data hash' do
          expect{
            put :update, params
            rating.reload
          }.to change{rating.data}
        end

        it 'updates rating attribute' do
          expect{
            put :update, params
            rating.reload
          }.to change{rating.diversity}.from(nil).to('5')
        end

        it 'redirect_to rating/todos' do
          put :update, params
          expect(response).to redirect_to rating_todos_path
        end
      end
    end
  end
end
