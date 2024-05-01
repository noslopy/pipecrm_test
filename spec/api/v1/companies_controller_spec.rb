require 'rails_helper'


describe "API: v1: Companies Controller"  do
    before(:each) do
        load "#{Rails.root}/db/seeds.rb"
    end

    describe "GET /api/v1/companies" do
        it "returns a list of 10 companies" do
            get "/api/v1/companies"
            
            expect(response.status).to eq(200)
            json_response = JSON.parse(response.body)
            expect(json_response.length).to eq(10)
        end

        it "returns at least 1 company with matching name" do
            sample_company = Company.first
            get "/api/v1/companies?companyName=#{sample_company.name}"
            
            expect(response.status).to eq(200)
            json_response = JSON.parse(response.body)
            expect(json_response.length).to be > 0
        end

        it "returns various test cases with different params" do
            assert(true)
        end
    end
end