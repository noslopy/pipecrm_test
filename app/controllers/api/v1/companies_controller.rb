class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company.left_outer_joins(:deals)
      .group(:id)
      .select(Arel.sql("companies.*, COALESCE(SUM(CASE WHEN deals.status = \"won\" THEN deals.amount END), 0) as total_amount"))
    companies.where!("companies.name LIKE ?", "%#{params['companyName']}%") if params['companyName']
    companies.where!("companies.industry LIKE ?", "%#{params['industry']}%") if params['industry']
    companies.where!("companies.employee_count > ?", params['minEmployee'].to_i) if params['minEmployee'] && params['minEmployee'].to_i
    companies.having!("SUM(CASE WHEN deals.status = \"won\" THEN deals.amount END) > ?", params['minimumDealAmount'].to_i) if params['minimumDealAmount'] && params['minimumDealAmount'].to_i
    render json: companies.as_json
  end
end
