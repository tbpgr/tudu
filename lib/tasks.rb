# encoding: utf-8
require 'task'
require 'tudu_file_keys'

# rubocop:disable ClassLength
module Tudu
  # = Tudu::Tasks
  class Tasks
    class << self
      # == add task to todos
      # === Params
      #- task_names : add task name list
      def add(*task_names)
        task_names.each do |task_name|
          if find_tasks(task_name)
            puts "#{task_name} is already exists."
            next
          end
          File.open(TuduPaths::TUDU_TODOS_FILE_PATH, 'a:UTF-8') do |f|
            f.puts task_name
          end
          puts "complete add todo '#{task_name}' to tudu/todos"
        end
      end

      # == remove task to todo
      # === Params
      #- task_names : remove task name list
      def remove(*task_names)
        task_names.each { |task_name|remove_each_task(task_name) }
      end

      # == choose todo => doing task
      # === Params
      #- task_name : target task name
      def choose(task_name)
        return if when_choose_no_todos?
        return unless when_choose_no_doings?
        task_name = get_first_todo_name_if_nil_or_empty task_name
        task = find_tasks(task_name)
        return if when_choose_no_task?(task, task_name)
        return unless when_choose_type_is_todo?(task, task_name)
        remove task_name
        write_doing(task_name)
        puts "complete add doings '#{task_name}'"
      end

      # == doing to done
      #- if doings size == 0, nothing todo.
      #- after move doing to done, next todo move to doing.
      def done
        return unless doings_to_dones
        todos_to_doings
      end

      # == get todos type tasks.
      # === Returns
      # return Array[Tasks]
      def todos
        get_tasks(TuduPaths::TUDU_TODOS_FILE)
      end

      # == get doings type tasks.
      # === Returns
      # return Array[Tasks]
      def doings
        get_tasks(TuduPaths::TUDU_DOINGS_FILE)
      end

      # == get dones type tasks.
      # === Returns
      # return Array[Tasks]
      def dones
        get_tasks(TuduPaths::TUDU_DONES_FILE)
      end

      # == get each type tasks.
      # === Params
      #- type : task type.if use nil, you can get all types task.
      # === Returns
      # return Array[Tasks]
      def get_tasks(type = nil)
        type.nil? ? all_tasks : get_each_tasks(type)
      end

      # == get each type tasks from file.
      # === Params
      #- type : task type.
      # === Returns
      # return Array[String]
      def get_tasks_from_file(file_name)
        File.read("./#{TuduPaths::TUDU_DIR}/#{file_name}").split("\n")
      end

      # == filter tasklist by search_word.
      # === Params
      #- tasks : task list.
      #- search_word : filtering word.
      # === Returns
      # return filterd task list
      def filter_tasks(tasks, search_word)
        return tasks if search_word.nil?
        tasks.select { |task|task.name.match(/.*#{search_word}.*/) }
      end

      # == find task from all tasks.
      # === Params
      #- task_name : task name.
      # === Returns
      # return task
      def find_tasks(task_name)
        tasks = get_tasks
        tasks.select { |task|task.name == task_name }.first
      end

      # == display tasks progress
      # === Returns
      # return progress
      def progress
        total_count = get_tasks.size
        dones_count = dones.size
        percent = total_count == 0 ? 0 : percentage(dones_count, total_count)
        prefix = "#{dones_count}/#{total_count}|"
        done_bar = '=' * (percent / 10)
        rest_bar = ' ' * (10 - (percent / 10))
        progress_bar = "#{done_bar}>#{rest_bar}"
        sufix = "|#{percent}%"
        "#{prefix}#{progress_bar}#{sufix}"
      end

      private

      def percentage(base, total)
        (base.to_f / total.to_f * 100).round
      end

      def get_first_todo_name_if_nil_or_empty(task_name)
        task_name.nil? || task_name.empty? ? todos.first.name : task_name
      end

      def get_each_tasks(type)
        tasks = []
        get_tasks_from_file(type).each { |task|tasks << Task.new(type, task) }
        tasks
      end

      def all_tasks
        tasks = []
        TuduPaths::TASK_FILES.each_value do |each_type|
          tasks += get_each_tasks(each_type)
        end
        tasks
      end

      def include_task?(tasks, task_name)
        tasks.include? task_name
      end

      def remove_each_task(task_name)
        can_find = false
        TuduPaths::TASK_FILES.each_value do |rf|
          tasks = get_tasks_from_file(rf)
          next unless include_task?(tasks, task_name)
          remove_task(tasks, task_name, "./#{TuduPaths::TUDU_DIR}/#{rf}")
          can_find = true
          break
        end
        puts "no such todo '#{task_name}'" unless can_find
      end

      def remove_task(tasks, task_name, file_path)
        tasks.delete(task_name)
        contents = tasks.size == 0 ? '' : tasks.join("\n") + "\n"
        File.open(file_path, 'w:UTF-8') { |wf|wf.print contents }
        puts "complete remove todo '#{task_name}' from #{file_path}"
      end

      def when_choose_no_todos?
        return false unless todos.size == 0
        puts 'todos is empty.'
        true
      end

      def when_choose_no_doings?
        return true if doings.size == 0
        puts 'todos is empty.'
        false
      end

      def when_choose_no_task?(task, task_name)
        return true if task.nil?
        puts "#{task_name} not exists"
        false
      end

      def when_choose_type_is_todo?(task, task_name)
        return true if task.todo?
        puts "#{task_name} is not exists in todos. #{task_name} in #{task.type}" # rubocop:disable LineLength
        false
      end

      def doings_to_dones
        _doings = doings
        if _doings.size == 0
          puts 'there is no doing task.before done, you must choose task.'
          return false
        end
        write_doing('')
        write_done(_doings.first.name)
        true
      end

      def write_doing(text)
        File.open(TuduPaths::TUDU_DOINGS_FILE_PATH, 'w:UTF-8') do |f|
          if text.empty?
            f.print(text)
          else
            f.puts text
          end
        end
      end

      def write_done(text)
        File.open(TuduPaths::TUDU_DONES_FILE_PATH, 'a:UTF-8') do |f|
          f.puts text
        end
      end

      def todos_to_doings
        _todos = todos
        return if finish?(_todos)
        deleted_todos = _todos.dup
        deleted_todos.delete_at 0
        File.open(TuduPaths::TUDU_TODOS_FILE_PATH, 'w:UTF-8') do |f|
          deleted_todos.each { |task|f.puts task.name }
        end
        File.open(TuduPaths::TUDU_DOINGS_FILE_PATH, 'w:UTF-8') do |f|
          f.puts _todos.first.name
        end
      end

      def finish?(_todos)
        return false unless _todos.size == 0
        puts 'All Tasks Finish!!' if doings.size == 0
        true
      end
    end
  end
end
# rubocop:enable ClassLength
