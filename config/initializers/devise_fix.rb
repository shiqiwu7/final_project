Rails.application.config.to_prepare do
  begin
    if ActiveRecord::Base.connection.table_exists?('users')
      if defined?(User)
        User.class_eval do
          reset_column_information
        end
      end
    end
  rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad
    Rails.logger.warn "Skipping devise fix - database not available yet"
  end
end