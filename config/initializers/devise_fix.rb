Rails.application.config.after_initialize do
  if defined?(User) && User.table_exists?
    # Make sure User model has Devise's required attributes
    User.class_eval do
      # Force column information reload
      reset_column_information
    end
  end
end