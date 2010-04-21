class AddDelayedJobIndex < ActiveRecord::Migration
  def self.up
    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'
  end

  def self.down
  end
end
