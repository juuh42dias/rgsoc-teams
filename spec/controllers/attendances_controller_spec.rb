require 'spec_helper'

RSpec.describe AttendancesController do
  let!(:attendance) { FactoryGirl.create(:attendance, :student_attendance, confirmed: false) }
  let!(:user) { attendance.team.students.first }

  before :each do
    sign_in user
  end

  describe 'PATCH update' do

    it 'updates the attendance' do
      request.env["HTTP_REFERER"] = "/back"
      post :update, params: { id: attendance.id, attendance: { confirmed: true } }
      expect(response).to redirect_to "/back"
      expect(attendance.reload.confirmed).to be_truthy
    end

    it 'does not update the attendance of another user' do
      other_attendance = create :attendance, confirmed: false
      expect {
        post :update, params: { id: other_attendance.id, attendance: { confirmed: true } }
      }.to raise_error ActiveRecord::RecordNotFound
      expect(attendance.reload.confirmed).to be_falsy
    end

    context 'when the user is not a student' do
      let!(:user) { FactoryGirl.create(:user) }

      it 'throw  a not found status' do
        expect {
          post :update, params: { id: attendance.id, attendance: { confirmed: true } }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when the user is a student from another team' do
      let!(:user) { FactoryGirl.create(:student) }

      it 'throw a not found status' do
        expect {
          post :update, params: { id: attendance.id, attendance: { confirmed: true } }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE destroy' do

    it 'deletes the attendance' do
      request.env["HTTP_REFERER"] = "/back"
      expect {
        delete :destroy, params: { id: attendance.id }
      }.to change { Attendance.count }.by(-1)
      expect(response).to redirect_to "/back"
    end

    it 'does not deletes the attendance of another user' do
      other_attendance = create :attendance
      request.env["HTTP_REFERER"] = "/back"
      expect {
        delete :destroy, params: { id: other_attendance.id }
      }.to raise_error ActiveRecord::RecordNotFound
      expect(Attendance.count).to eql 2
    end
  end

end
