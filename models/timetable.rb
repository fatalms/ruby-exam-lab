# frozen_string_literal: true

# timeTable class
TimeTable = Struct.new(:id, :day, :number_pair, :subject, :teacher, :audience, :group, keyword_init: true) do
  def to_s
    "Предмет: #{subject}<br />Преподаватель: #{teacher}<br /> Аудитория: #{audience}<br />"
  end
end
