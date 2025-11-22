module Searchable
    extend ActiveSupport::Concern
    
    included do
        scope :search, -> (query) {
            return all if query.blank?

            search_term = "%#{sanitize_sql_like(query)}%"
            searchable_columns = searchable_columns() || column_names.map(&:to_s)
            conditions = searchable_columns.map { |column| "#{column} LIKE :query" }.join(" OR ")
            where(conditions, query: search_term)
        }
    end
end