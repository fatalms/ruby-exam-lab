# frozen_string_literal: true

# module adding methods for checking input data. 1 task
module DataCheckingModule
  def new_group(params)
    errors = []
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      if elem.number_pair.eql?(params[:number_pair]) && elem.group.eql?(params[:group])
        errors.concat(['В любой момент времени группа должна быть максимум на одном занятии'])
      end
    end
    errors
  end

  def new_teacher(params)
    errors = []
    errors.concat(['Общее число предметов у преподавателя не должно превышать 8 штук']) if check_1(params)
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      if check_2(params, elem)
        errors.concat(['В любой момент времени преподаватель должен вести максимум один предмет'])
      end
      if check_3(params, elem)
        errors.concat(['В любой момент времени преподаватель должен находиться максимум в одном месте'])
      end
    end
    errors
  end

  def new_audience(params)
    errors = []
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      if check_4(params, elem)
        errors.concat(['В любой момент времени в аудитории может преподаваться максимум один предмет'])
      end
      if check_5(params, elem)
        errors.concat(['В любой момент времени в аудитории может находиться максимум одним преподаватель'])
      end
    end
    errors
  end

  def number_teacher_subj(teacher)
    subj = []
    @timetable_list.each_value do |value|
      subj.append(value.subject) if value.teacher.eql?(teacher)
    end
    subj.uniq
  end

  def check_1(params)
    subj = number_teacher_subj(params[:teacher])
    !subj.include?(params[:subject]) && subj.length >= 7
  end

  def check_2(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.teacher.eql?(params[:teacher]) &&
      !elem.subject.eql?(params[:subject])
  end

  def check_3(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.teacher.eql?(params[:teacher]) &&
      !elem.audience.eql?(params[:audience])
  end

  def check_4(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.audience.eql?(params[:audience]) &&
      !elem.subject.eql?(params[:subject])
  end

  def check_5(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.audience.eql?(params[:audience]) &&
      !elem.teacher.eql?(params[:teacher])
  end
end
