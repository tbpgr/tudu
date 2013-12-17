# encoding: utf-8

module Tudu
  #= Tudu::Tasks
  class Tasks
    #== Tudufile key
    TUDU_FILE_KEY = :tudufile
    #== todo key
    TUDU_TODO_KEY = :todo
    #== doing key
    TUDU_DOING_KEY = :doing
    #== done key
    TUDU_DONE_KEY = :done
    #== file's key
    TUDU_KEYS = [TUDU_FILE_KEY, TUDU_TODO_KEY, TUDU_DOING_KEY, TUDU_DONE_KEY]

    #== Tudufile file name
    TUDU_FILE = "Tudufile"
    #== Tudufile file name
    TUDU_DIR = "tudu"
    #== todo file name
    TUDU_TODOS_FILE = "todos"
    #== todo file path
    TUDU_TODOS_FILE_PATH = "./#{TUDU_DIR}/#{TUDU_TODOS_FILE}"
    #== doing file name
    TUDU_DOINGS_FILE = "doings"
    #== doing file path
    TUDU_DOINGS_FILE_PATH = "./#{TUDU_DIR}/#{TUDU_DOINGS_FILE}"
    #== done file name
    TUDU_DONES_FILE = "dones"
    #== done file path
    TUDU_DONES_FILE_PATH = "./#{TUDU_DIR}/#{TUDU_DONES_FILE}"
    #== file names
    INIT_FILES = {
      TUDU_FILE_KEY => TUDU_FILE,
      TUDU_TODO_KEY => TUDU_TODOS_FILE,
      TUDU_DOING_KEY => TUDU_DOINGS_FILE,
      TUDU_DONE_KEY => TUDU_DONES_FILE
    }
    #== task file names
    TASK_FILES = {
      TUDU_TODO_KEY => TUDU_TODOS_FILE,
      TUDU_DOING_KEY => TUDU_DOINGS_FILE,
      TUDU_DONE_KEY => TUDU_DONES_FILE
    }

    #== Tudufile file template
    TUDU_FILE_TEMPLATE =<<-EOS
# encoding: utf-8

# !!!!!!! in tudu ver 0.0.1 this file not using !!!!!!!

# if you want to use notification, set target type. default => :none
# you can set :none, :mail
# target_type :mail

# if you want to use notification, set targets. default => []
# if you choose target_type none, you must not set targets.
# if you choose mail, you must set target email addresses.
# targets ["target1@abcdefg", "target2@abcdefg"]
    EOS

    #== todo file template
    TUDU_TODOS_FILE_TEMPLATE = ""
    #== doing file template
    TUDU_DOINGS_FILE_TEMPLATE = ""
    #== done file template
    TUDU_DONES_FILE_TEMPLATE = ""

    #== template files
    INIT_FILES_TEMPLATE = {
      TUDU_FILE_KEY => TUDU_FILE_TEMPLATE,
      TUDU_TODO_KEY => TUDU_TODOS_FILE_TEMPLATE,
      TUDU_DOING_KEY => TUDU_DOINGS_FILE_TEMPLATE,
      TUDU_DONE_KEY => TUDU_DONES_FILE_TEMPLATE
    }

    #== task type [todo, doing, done]
    attr_accessor :type
    #== task name [uniq]
    attr_accessor :name

    class << self
      #== add task to todos
      #=== Params
      #- task_names : add task name list
      def add(*task_names)
        task_names.each do |task_name|
          if find_tasks(task_name)
            puts "#{task_name} is already exists.";
            next
          end
          File.open(TUDU_TODOS_FILE_PATH, "a:UTF-8") {|f|f.puts task_name}
          puts "complete add todo '#{task_name}' to tudu/todos"
        end
      end

      #== remove task to todo
      #=== Params
      #- task_names : remove task name list
      def remove(*task_names)
        task_names.each do |task_name|
          can_find = false
          TASK_FILES.each_value do |rf|
            tasks = get_tasks_from_file(rf)
            next unless has_task?(tasks, task_name)
            remove_task(tasks, task_name, "./#{TUDU_DIR}/#{rf}")
            can_find = true
            break
          end
          puts "no such todo '#{task_name}'" unless can_find
        end
      end

      #== choose todo => doing task
      #=== Params
      #- task_name : target task name
      def choose(task_name)
        if get_todos.size == 0
          puts "todos is empty."
          return
        end
        if get_doings.size > 0
          puts "before choose, you must done current doings."
          return
        end
        task_name = get_first_todo_name_if_nil_or_empty task_name
        task = find_tasks(task_name)
        if task.nil?
          puts "#{task_name} not exists"
          return
        end
        unless task.todo?
          puts "#{task_name} is not exists in todos. #{task_name} in #{task.type}"
          return
        end
        remove task_name
        File.open(TUDU_DOINGS_FILE_PATH, "w:UTF-8") {|f|f.puts task_name}
        puts "complete add doings '#{task_name}'"
      end

      #== doing to done
      #- if doings size == 0, nothing todo.
      #- after move doing to done, next todo move to doing.
      def done
        return unless doings_to_dones
        todos_to_doings
      end

      #== get todos type tasks.
      #=== Returns
      # return Array[Tasks]
      def get_todos
        get_tasks(TUDU_TODOS_FILE)
      end

      #== get doings type tasks.
      #=== Returns
      # return Array[Tasks]
      def get_doings
        get_tasks(TUDU_DOINGS_FILE)
      end

      #== get dones type tasks.
      #=== Returns
      # return Array[Tasks]
      def get_dones
        get_tasks(TUDU_DONES_FILE)
      end

      #== get each type tasks.
      #=== Params
      #- type : task type.if use nil, you can get all types task.
      #=== Returns
      # return Array[Tasks]
      def get_tasks(type = nil)
        type.nil? ? get_all_tasks : get_each_tasks(type)
      end

      #== get each type tasks from file.
      #=== Params
      #- type : task type.
      #=== Returns
      # return Array[String]
      def get_tasks_from_file(file_name)
        File.read("./#{TUDU_DIR}/#{file_name}").split("\n")
      end

      #== filter tasklist by search_word.
      #=== Params
      #- tasks : task list.
      #- search_word : filtering word.
      #=== Returns
      # return filterd task list
      def filter_tasks(tasks, search_word)
        return tasks if search_word.nil?
        tasks.select {|task|task.name.match /.*#{search_word}.*/}
      end

      #== find task from all tasks.
      #=== Params
      #- task_name : task name.
      #=== Returns
      # return task
      def find_tasks(task_name)
        tasks = get_tasks
        tasks.select {|task|task.name == task_name}.first
      end

      #== display tasks progress
      #=== Returns
      # return progress
      def progress
        total_count = get_tasks.size
        dones_count = get_dones.size
        percent = total_count == 0 ? 0 : (dones_count.to_f / total_count.to_f * 100).round
        prefix = "#{dones_count}/#{total_count}|"
        done_bar = "="*(percent/10)
        rest_bar = " "*(10-(percent/10))
        progress_bar = "#{done_bar}>#{rest_bar}"
        sufix = "|#{percent}%"
        "#{prefix}#{progress_bar}#{sufix}"
      end

      private
      def get_first_todo_name_if_nil_or_empty(task_name)
        (task_name.nil? || task_name.empty?) ? get_todos.first.name : task_name
      end

      def get_each_tasks(type)
        tasks = []
        get_tasks_from_file(type).each {|task|tasks << Tasks.new(type, task)}
        tasks
      end

      def get_all_tasks
        tasks = []
        TASK_FILES.each_value {|each_type|tasks += get_each_tasks(each_type)}
        tasks
      end

      def has_task?(tasks, task_name)
        tasks.include? task_name
      end

      def remove_task(tasks, task_name, file_path)
        tasks.delete(task_name)
        contents = tasks.size == 0 ? "" : tasks.join("\n") + "\n"
        File.open(file_path, "w:UTF-8") {|wf|wf.print contents}
        puts "complete remove todo '#{task_name}' from #{file_path}"
      end

      def doings_to_dones
        _doings = get_doings
        if _doings.size == 0
          puts "there is no doing task.before done, you must choose task."
          return false
        end
        File.open(TUDU_DOINGS_FILE_PATH, "w:UTF-8") {|f|f.print ""}
        File.open(TUDU_DONES_FILE_PATH, "a:UTF-8") {|f|f.puts _doings.first.name}
        true
      end

      def todos_to_doings
        _todos = get_todos
        if _todos.size == 0
          puts "All Tasks Finish!!" if get_doings.size == 0
          return
        end

        deleted_todos = _todos.dup
        deleted_todos.delete_at 0
        File.open(TUDU_TODOS_FILE_PATH, "w:UTF-8") do |f|
          deleted_todos.each {|task|f.puts task.name}
        end
        File.open(TUDU_DOINGS_FILE_PATH, "w:UTF-8") {|f|f.puts _todos.first.name}
      end
    end

    #== init task with setting task type and task name.
    def initialize(type, name)
      @type, @name = type, name
    end

    def todo?
      @type == "todos"
    end

    def doing?
      @type == "doings"
    end

    def done?
      @type == "dones"
    end

    def ==(other)
      if self.name == other.name
        return true if self.type == other.type
      end
      false
    end
  end
end
