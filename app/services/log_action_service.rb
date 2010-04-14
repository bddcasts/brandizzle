class LogActionService
  def initialize(log_klass = Log)
    @log_klass = log_klass
  end
  
  def update_brand_result(brand_result, user)
    @log_klass.create(
      :loggable => brand_result,
      :user => user)
  end
end