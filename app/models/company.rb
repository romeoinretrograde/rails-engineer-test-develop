class Company < ApplicationRecord
    include Searchable
    include CsvImportable

    validates :coc_number, presence: true, uniqueness: true
    validates :company_name, presence: true
    validates :city, presence: true
    
    def self.searchable_columns
        %w[coc_number company_name city]
    end
end