When /^the delayed job worker does (\d+) job$/ do |num|
  worker = Delayed::Worker.new
  worker.work_off(num.to_i)
end
