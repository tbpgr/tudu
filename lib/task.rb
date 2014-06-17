# encoding: utf-8

module Tudu
  # = Tudu::Task
  class Task
    # == task type [todo, doing, done]
    attr_accessor :type
    # == task name [uniq]
    attr_accessor :name

    # == init task with setting task type and task name.
    def initialize(type, name)
      @type, @name = type, name
    end

    def todo?
      @type == 'todos'
    end

    def doing?
      @type == 'doings'
    end

    def done?
      @type == 'dones'
    end

    def ==(other)
      return true if name == other.name && type == other.type
      false
    end
  end
end
