class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :today, -> { where(created_at: Time.current.beginning_of_day.in_time_zone(Time.zone)..Time.current.end_of_day.in_time_zone(Time.zone)) }
  scope :this_week, -> { where(created_at: Time.current.beginning_of_week.in_time_zone(Time.zone)..Time.current.end_of_week.in_time_zone(Time.zone)) }
  scope :this_month, -> { where(created_at: Time.current.beginning_of_month.in_time_zone(Time.zone)..Time.current.end_of_month.in_time_zone(Time.zone)) }
end
