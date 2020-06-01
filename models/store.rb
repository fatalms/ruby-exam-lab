# frozen_string_literal: true

require 'psych'
require_relative 'timetable_list'
require_relative 'timetable'

# Storage for all of our data
class Store
  attr_reader :timetable

  DATA_STORE = File.expand_path('../db/data.yaml', __dir__)

  def initialize
    @timetable = TimeTableList.new
    read_data
    at_exit { write_data }
  end

  def read_data
    return unless File.exist?(DATA_STORE)

    yaml_data = File.read(DATA_STORE)
    raw_data = Psych.load(yaml_data, symbolize_names: true)
    raw_data[:timetable].each do |raw_book|
      @timetable.add_real_item(TimeTable.new(**raw_book))
    end
  end

  def write_data
    raw_books = @timetable.all_items.map(&:to_h)
    yaml_data = Psych.dump({
                             timetable: raw_books
                           })
    File.write(DATA_STORE, yaml_data)
  end
end