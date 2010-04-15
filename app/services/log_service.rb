class LogService
  def initialize(log_klass = Log)
    @log_klass = log_klass
  end
  
  def updated_brand_result(brand_result, user)
    @log_klass.create(
      :loggable => brand_result,
      :user => user)
  end
  
  def created_comment(comment, user)
    @log_klass.create(
      :loggable => comment,
      :user => user)
  end
end