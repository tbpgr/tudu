# encoding: utf-8
require 'tudu/version'
require 'tasks'
require 'highline'

module Tudu
  # Tudu::Core
  class Core
    # == generate files [Tudufile, todos, doings, dones]
    def init
      Dir.mkdir Tudu::Tasks::TUDU_DIR unless File.exist? Tudu::Tasks::TUDU_DIR
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
      todo_list = todos search_word
      doing_list = doings search_word
      done_list = dones search_word
      todo_list, doing_list, done_list = coloring(options, todo_list, doing_list, done_list)
      categorise(options, todo_list, doing_list, done_list)
      todo_list + doing_list + done_list
    end

    # == search todos
    # === Params
    #- search_word : search word. enable regexp.
    def todos(search_word)
      todos_task(search_word).map(&:name)
    end

    # == search doings
    # === Params
    #- search_word : search word. enable regexp.
    def doings(search_word)
      doings_task(search_word).map(&:name)
    end

    # == search dones
    # === Params
    #- search_word : search word. enable regexp.
    def dones(search_word)
      dones_task(search_word).map(&:name)
    end

    # == display tasks progress
    # === Returns
    # return progress
    def progress
      Tudu::Tasks.progress
    end

    alias_method :now, :doings

    private

    def coloring(options, todo_list, doing_list, done_list)
      return todo_list, doing_list, done_list unless colored?(options)
      h = HighLine.new
      colored_todo_list = todo_list.map { |todo|h.color(todo, :red) }
      colored_doing_list = doing_list.map { |doing|h.color(doing, :yellow) }
      colored_done_list = done_list.map { |done|h.color(done, :cyan) }
      [colored_todo_list, colored_doing_list, colored_done_list]
    end

    def categorise(options, todo_list, doing_list, done_list)
      return unless categorised?(options)
      todo_list.insert(0, '========TODOS========')
      doing_list.insert(0, '========DOINGS========')
      done_list.insert(0, '========DONES========')
    end

    def colored?(options)
      options && options[:color]
    end

    def categorised?(options)
      options && options[:category]
    end

    def todos_task(search_word)
      Tudu::Tasks.filter_tasks(Tudu::Tasks.todos, search_word)
    end

    def doings_task(search_word)
      Tudu::Tasks.filter_tasks(Tudu::Tasks.doings, search_word)
    end

    def dones_task(search_word)
      Tudu::Tasks.filter_tasks(Tudu::Tasks.dones, search_word)
    end
  end
end
