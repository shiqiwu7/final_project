if Rails.env.production?
  Rails.application.config.after_initialize do
    User.reset_column_information
  end
end