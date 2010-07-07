Factory.define(:log) do |f|
  f.loggable_attributes { |l| l.loggable.logged_attributes }
  f.association :user
  f.association :team
end

Factory.define(:brand_result_log, :parent => :log) do |f|
  f.association :loggable, :factory => :brand_result
end

{ "positive" => 1, "neutral" => 0, "negative" => -1}.each do |k, v|
  Factory.define(:"#{k}_brand_result_log", :parent => :brand_result_log) do |f|
    f.loggable_attributes { |l| { 'body' => l.loggable.result.body, 'temperature' => v } }
  end
end

['follow_up', 'done', 'normal' ].each do |state|
  Factory.define(:"#{state}_brand_result_log", :parent => :brand_result_log) do |f|
    f.loggable_attributes { |l| { 'body' => l.loggable.result.body, 'state' => state } }
  end
end

Factory.define(:comment_log, :parent => :log) do |f|
  f.association :loggable, :factory => :comment
end