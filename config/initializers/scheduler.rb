require 'rufus-scheduler'

unless Rails.env.test?
  s = Rufus::Scheduler.singleton
  s.every '5s' do
    GetPackagesJob.perform_now
  end
end
