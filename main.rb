require 'date'

class Event
  attr_accessor :title, :date, :category, :is_periodic

  def initialize(title, date, category, is_periodic = false)
    @title = title
    @date = date
    @category = category
    @is_periodic = is_periodic
  end

  def to_s
    "#{@title} (#{@date.strftime('%Y-%m-%d')}, #{@category})"
  end
end

class Organizer
  attr_accessor :events

  def initialize
    @events = []
  end

  def add_event(title, date, category, is_periodic = false)
    event = Event.new(title, date, category, is_periodic)
    @events << event
    puts "Event added: #{event}"
  end

  def view_events(start_date, end_date, sort_by = :date, category = nil)
    selected_events = @events.select do |event|
      event.date.between?(start_date, end_date) &&
        (category.nil? || event.category == category)
    end

    sorted_events = case sort_by
                    when :date
                      selected_events.sort_by { |event| event.date }
                    when :category
                      selected_events.sort_by { |event| event.category }
                    else
                      selected_events
                    end

    sorted_events.each { |event| puts event }
  end

  def get_reminders(days_ahead = 7)
    today = Date.today
    upcoming_events = @events.select do |event|
      event.date.between?(today, today + days_ahead)
    end

    upcoming_events.each do |event|
      puts "Reminder: #{event} is coming up on #{event.date}"
    end
  end
end

# Приклад використання
organizer = Organizer.new

organizer.add_event('Meeting', Date.new(2023, 12, 10), 'Work', true)
organizer.add_event('Birthday Party', Date.new(2023, 12, 15), 'Personal')
organizer.add_event('Conference', Date.new(2024, 1, 5), 'Work')
organizer.add_event('Weekly Report', Date.new(2023, 12, 8), 'Work', true)

puts "\nAll Events:"
organizer.events.each { |event| puts event }

puts "\nFiltered Events:"
organizer.view_events(Date.new(2023, 12, 1), Date.new(2023, 12, 31), :date, 'Work')

puts "\nReminders:"
organizer.get_reminders
