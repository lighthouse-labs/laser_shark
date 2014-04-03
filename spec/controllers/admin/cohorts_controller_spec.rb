require 'spec_helper'

describe Admin::CohortsController do
	let!(:cohort) { create(:cohort) }
	describe "#index" do
		it "assigns @cohorts" do
			get :index
			expect(assigns(:cohorts)).to match_array [cohort] 
		end
	end
end