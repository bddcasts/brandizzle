module LogsHelper
  def present_logs(logs, &block)
    logs.each_with_presenter(LogPresenter, :log, &block)
  end
    
  def present_log(log)
    LogPresenter.new(:log => log)
  end
end