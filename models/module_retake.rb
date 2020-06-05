# frozen_string_literal: true

# the module contains functions for working with 'retake' data. 6 task
module RetakeModule
  def retake_days(params)
    data = all_data
    teacher = params['teacher']
    groups = params['groups'].split(' ')

    retake = retake_by_teacher(teacher, data) & retake_by_groups(groups, data)
    return nil if retake.empty?

    retake.each do |day|
      auditory = retake_by_audience(day, data, teacher)
      return day.append(auditory[0]) if !auditory.empty?
    end
    nil
  end

  def retake_by_teacher(teacher, data)
    days = []
    data.each do |key, day|
      (1..5).each do |i|
        if day.empty?
          days.append([key, i, i + 1])
          next
        end
        next if check_for_teacher(day, teacher, i)

        days.append([key, i, i + 1])
      end
    end
    days
  end

  def check_for_teacher(day, teacher, count)
    if day.key?(count)
      day[count].each do |item|
        return true if item.teacher.eql?(teacher)
      end
    end
    if day.key?(count + 1)
      day[count].each do |item|
        return true if item.teacher.eql?(teacher)
      end
    end
    false
  end

  def retake_by_audience(day, data, teacher)
    all_audience = all_audience_by_teacher(teacher)
    return all_audience if data[day[0]].empty?

    data[day[0]][day[1]].each do |item|
      all_audience.delete(item.audience)
    end

    data[day[0]][day[2]].each do |item|
      all_audience.delete(item.audience)
    end
    all_audience
  end

  def all_audience_by_teacher(teacher)
    array = []
    @timetable_list.each_value do |value|
      array.append(value.audience) if value.teacher.eql?(teacher)
    end
    array.uniq
  end

  def retake_by_groups(groups, data)
    days = []
    data.each do |key, day|
      (1..5).each do |i|
        if day.empty?
          days.append([key, i, i + 1])
          next
        end
        next if check_for_groups(day, groups, i)

        days.append([key, i, i + 1])
      end
    end
    days
  end

  def check_for_groups(day, groups, count)
    if day.key?(count)
      day[count].each do |item|
        return true if groups.map { |group| item.group.eql?(group) }.include?(true)
      end
    end
    if day.key?(count + 1)
      day[count].each do |item|
        return true if groups.map { |group| item.group.eql?(group) }.include?(true)
      end
    end
    false
  end

  def groups?(param)
    errors = []
    all = all_groups
    groups = param.split(' ')
    groups.each do |group|
      errors.concat([group]) if !all.include?(group)
    end
    errors.uniq
  end

  def all_groups
    array = []
    @timetable_list.each_value do |value|
      array.append(value.group)
    end
    array.uniq.sort
  end
end
