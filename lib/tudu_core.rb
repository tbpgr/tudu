# encoding: utf-8
require 'tudu/version'
require 'tasks'

module Tudu
  # Tudu::Core
  class Core
    # == generate files [Tudufile, todos, doings, dones]
    def init
      Dir.mkdir Tudu::Tasks::TUDU_DIR unless File.exists? Tudu::Tasks::TUDU_DIR
      Tudu::Tasks::TUDU_KEYS.each do |key|
        File.open("./tudu/#{Tudu::Tasks::INIT_FILES[key]}", 'w:UTF-8') { |f|f.print Tudu::Tasks::INIT_FILES_TEMPLATE[key] }
      end
    end

    # == add task to todo
    # === Params
    #- task_names : add task name list
    def add(*task_names)
      Tudu::Tasks.add(*task_names)
    end

    # == remove task to todo
    # === Params
    #- task_names : remove task name list
    def remove(*task_names)
      Tudu::Tasks.remove(*task_names)
    end

    # == choose todo => doing task
    # === Params
    #- task_name : target task name
    def choose(task_name)
      Tudu::Tasks.choose task_name
    end

    # == doing to done
    #- if doings size == 0, nothing todo.
    #- after move doing to done, next todo move to doing.
    def done
      Tudu::Tasks.done
    end

    # == search tasks
    # === Params
    #- search_word : search word. enable regexp.
    #- options : options.
    def tasks(search_word, options)
      tasks = Tudu::Tasks.filter_tasks(Tudu::Tasks.get_tasks, search_word).map(&:name)
      is_caregory = (!options.nil? && options[:category])
      is_caregory ? categorized_tasks(tasks, search_word) : tasks
    end

    # == search todos
    # === Params
    #- search_word : search word. enable regexp.
    def todos(search_word)
      Tudu::Tasks.filter_tasks(Tudu::Tasks.get_todos, search_word).map(&:name)
    end

    # == search doings
    # === Params
    #- search_word : search word. enable regexp.
    def doings(search_word)
      Tudu::Tasks.filter_tasks(Tudu::Tasks.get_doings, search_word).map(&:name)
    end

    # == search dones
    # === Params
    #- search_word : search word. enable regexp.
    def dones(search_word)
      Tudu::Tasks.filter_tasks(Tudu::Tasks.get_dones, search_word).map(&:name)
    end

    # == display tasks progress
    # === Returns
    # return progress
    def progress
      Tudu::Tasks.progress
    end

    def categorized_tasks(tasks, search_word)
      ret = []
      tasks = Tudu::Tasks.filter_tasks(Tudu::Tasks.get_tasks, search_word)
      ret << '========TODOS========'
      ret << tasks.select { |task|task.type == Tudu::Tasks::TUDU_TODOS_FILE }.map(&:name).join("\n")
      ret << ''
      ret << '========DOINGS========'
      ret << tasks.select { |task|task.type == Tudu::Tasks::TUDU_DOINGS_FILE }.map(&:name).join("\n")
      ret << ''
      ret << '========DONES========'
      ret << tasks.select { |task|task.type == Tudu::Tasks::TUDU_DONES_FILE }.map(&:name).join("\n")
      ret
    end

    alias :now :doings
  end
end
