class Plan < Settingslogic
  source "#{Rails.root}/config/plans.yml"
  namespace Rails.env
  load!
end
