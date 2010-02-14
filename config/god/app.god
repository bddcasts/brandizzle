def this_file
  @this_file ||= File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
end

def rails_root
  @rails_root ||= File.expand_path(File.dirname(this_file) + '/../..')
end

def rails_env
  @rails_env ||= case rails_root
  when /aissac/ then "aissac"
  else "development"
  end
end

3.times do |num|
  God.watch do |w|
    w.name = "dj-#{num}"
    w.group = "delayed_job"
    
    w.uid = 'brandizzle'
    w.gid = 'brandizzle'
    
    w.interval = 30.seconds
    w.start = "/opt/ruby-enterprise-current/bin/rake -f #{rails_root}/Rakefile jobs:work RAILS_ENV=#{rails_env}"
  
    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 300.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
