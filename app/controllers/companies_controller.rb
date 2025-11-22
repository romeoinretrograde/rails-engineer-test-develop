class CompaniesController < ApplicationController
    def index
        @companies = Company.search(params[:query]).limit(100)
    end

    def admin
    end

    def import
        if params[:file].present?
            Company.import_from_csv(params[:file])
            redirect_to admin_companies_path, notice: "Companies imported successfully!"
        else
            redirect_to admin_companies_path, alert: "Please select a file"
        end
    end
end
