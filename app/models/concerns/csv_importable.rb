module CsvImportable
    extend ActiveSupport::Concern

    class_methods do

        def import_from_csv(file, batch_size: 500)
            require 'csv'

            records_to_import = []
            unique_key = extract_unique_key
            timestamp = Time.current

            CSV.foreach(file.path, headers: true, col_sep: ';') do |row|
                next if row[unique_key.to_s].blank?

                records_to_import << row.to_hash.transform_keys(&:to_sym).merge(
                    created_at: timestamp,
                    updated_at: timestamp
                )

                if records_to_import.size >= batch_size
                    import_batch(records_to_import, unique_key)
                    records_to_import.clear
                end
            end

            import_batch(records_to_import, unique_key) if records_to_import.any?
        end

        private

        def extract_unique_key
            validators
                .select { |v| v.is_a?(ActiveRecord::Validations::UniquenessValidator) }
                .flat_map(&:attributes).first || :id
        end

        def import_batch(records, unique_key)
            upsert_all(records, unique_by: unique_key)
        end
    end
end