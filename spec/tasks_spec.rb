# encoding: utf-8
require "spec_helper"
require "tudu_core"
require "tasks"

describe Tudu::Tasks do

  context :todo? do
    cases = [
      {
        case_no: 1,
        case_title: "todo task",
        name: "task_name",
        type: "todos",
        expected: true,
      },
      {
        case_no: 2,
        case_title: "not todo task",
        name: "task_name",
        type: "doings",
        expected: false,
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_task = Tudu::Tasks.new(c[:type], c[:name])

          # -- when --
          actual = tudu_task.todo?

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before

      end

      def case_after(c)
        # implement each case after
      end
    end
  end

  context :doing? do
    cases = [
      {
        case_no: 1,
        case_title: "doing task",
        name: "task_name",
        type: "doings",
        expected: true,
      },
      {
        case_no: 2,
        case_title: "not doing task",
        name: "task_name",
        type: "todos",
        expected: false,
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_task = Tudu::Tasks.new(c[:type], c[:name])

          # -- when --
          actual = tudu_task.doing?

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before

      end

      def case_after(c)
        # implement each case after
      end
    end
  end

  context :done? do
    cases = [
      {
        case_no: 1,
        case_title: "done task",
        name: "task_name",
        type: "dones",
        expected: true,
      },
      {
        case_no: 2,
        case_title: "not done task",
        name: "task_name",
        type: "doings",
        expected: false,
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_task = Tudu::Tasks.new(c[:type], c[:name])

          # -- when --
          actual = tudu_task.done?

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before

      end

      def case_after(c)
        # implement each case after
      end
    end
  end


  context :get_tasks_from_file do
    cases = [
      {
        case_no: 1,
        case_title: "get todos from file",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        expected: ["task1", "task2", "task3"],
      },
      {
        case_no: 2,
        case_title: "get doings from file",
        type: "doings",
        texts: ["task1", "task2", "task3"],
        expected: ["task1", "task2", "task3"],
      },
      {
        case_no: 3,
        case_title: "get done from file",
        type: "dones",
        texts: ["task1", "task2", "task3"],
        expected: ["task1", "task2", "task3"],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          actual = Tudu::Tasks.get_tasks_from_file(c[:type])

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir("./#{Tudu::Tasks::TUDU_DIR}")
        File.open("./#{Tudu::Tasks::TUDU_DIR}/#{c[:type]}", "w") {|f|f.puts c[:texts].join("\n")}
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :get_tasks do
    cases = [
      {
        case_no: 1,
        case_title: "get todos from file",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        expected: [
          Tudu::Tasks.new("todos", "task1"),
          Tudu::Tasks.new("todos", "task2"),
          Tudu::Tasks.new("todos", "task3"),
          ],
      },
      {
        case_no: 2,
        case_title: "get doings from file",
        type: "doings",
        texts: ["task1", "task2", "task3"],
        expected: [
          Tudu::Tasks.new("doings", "task1"),
          Tudu::Tasks.new("doings", "task2"),
          Tudu::Tasks.new("doings", "task3"),
          ],
      },
      {
        case_no: 3,
        case_title: "get done from file",
        type: "dones",
        texts: ["task1", "task2", "task3"],
        expected: [
          Tudu::Tasks.new("dones", "task1"),
          Tudu::Tasks.new("dones", "task2"),
          Tudu::Tasks.new("dones", "task3"),
          ],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          actual = Tudu::Tasks.get_tasks(c[:type])

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir("./#{Tudu::Tasks::TUDU_DIR}")
        File.open("./#{Tudu::Tasks::TUDU_DIR}/#{c[:type]}", "w") {|f|f.puts c[:texts].join("\n")}
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :get_todos do
    cases = [
      {
        case_no: 1,
        case_title: "get doings from file",
        type: "doings",
        texts: ["task1", "task2", "task3"],
        expected: [
          Tudu::Tasks.new("doings", "task1"),
          Tudu::Tasks.new("doings", "task2"),
          Tudu::Tasks.new("doings", "task3"),
          ],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          actual = Tudu::Tasks.get_doings

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir("./#{Tudu::Tasks::TUDU_DIR}")
        File.open("./#{Tudu::Tasks::TUDU_DIR}/#{c[:type]}", "w") {|f|f.puts c[:texts].join("\n")}
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :get_dones do
    cases = [
      {
        case_no: 1,
        case_title: "get done from file",
        type: "dones",
        texts: ["task1", "task2", "task3"],
        expected: [
          Tudu::Tasks.new("dones", "task1"),
          Tudu::Tasks.new("dones", "task2"),
          Tudu::Tasks.new("dones", "task3"),
          ],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          actual = Tudu::Tasks.get_dones

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir("./#{Tudu::Tasks::TUDU_DIR}")
        File.open("./#{Tudu::Tasks::TUDU_DIR}/#{c[:type]}", "w") {|f|f.puts c[:texts].join("\n")}
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :find_tasks do
    cases = [
      {
        case_no: 1,
        case_title: "find todos from tasks",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        search_name: "task1",
        expected: Tudu::Tasks.new("todos", "task1")
      },
      {
        case_no: 2,
        case_title: "find doings from tasks",
        type: "doings",
        texts: ["task1", "task2", "task3"],
        search_name: "task1",
        expected: Tudu::Tasks.new("doings", "task1")
      },
      {
        case_no: 3,
        case_title: "find done from tasks",
        type: "dones",
        texts: ["task1", "task2", "task3"],
        search_name: "task1",
        expected: Tudu::Tasks.new("dones", "task1")
      },
      {
        case_no: 4,
        case_title: "not find",
        type: "dones",
        texts: ["task1", "task2", "task3"],
        search_name: "task4",
        expected: nil
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          actual = Tudu::Tasks.find_tasks c[:search_name]

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Tudu::Core.new.init
        Dir.mkdir(Tudu::Tasks::TUDU_DIR) unless File.exists?(Tudu::Tasks::TUDU_DIR)
        File.open("./#{Tudu::Tasks::TUDU_DIR}/#{c[:type]}", "w") {|f|f.puts c[:texts].join("\n")}
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :choose do
    cases = [
      {
        case_no: 1,
        case_title: "choose task",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        choose: "task1",
        expected: [
          Tudu::Tasks.new("todos", "task2"),
          Tudu::Tasks.new("todos", "task3"),
          Tudu::Tasks.new("doings", "task1"),
        ]
      },
      {
        case_no: 2,
        case_title: "aleady exists doing",
        type: "doings",
        texts: ["task1", "task2", "task3"],
        choose: "task1",
        expected: [
          Tudu::Tasks.new("doings", "task1"),
          Tudu::Tasks.new("doings", "task2"),
          Tudu::Tasks.new("doings", "task3"),
        ]
      },
      {
        case_no: 3,
        case_title: "not exists task",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        choose: "task4",
        expected: [
          Tudu::Tasks.new("todos", "task1"),
          Tudu::Tasks.new("todos", "task2"),
          Tudu::Tasks.new("todos", "task3"),
        ]
      },
      {
        case_no: 4,
        case_title: "task exists, but dones",
        type: "dones",
        texts: ["task1", "task2", "task3"],
        choose: "task1",
        expected: [
          Tudu::Tasks.new("dones", "task1"),
          Tudu::Tasks.new("dones", "task2"),
          Tudu::Tasks.new("dones", "task3"),
        ]
      },
      {
        case_no: 5,
        case_title: "task exists, empty args",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        choose: "",
        expected: [
          Tudu::Tasks.new("todos", "task2"),
          Tudu::Tasks.new("todos", "task3"),
          Tudu::Tasks.new("doings", "task1"),
        ]
      },
      {
        case_no: 6,
        case_title: "task exists, nil args",
        type: "todos",
        texts: ["task1", "task2", "task3"],
        choose: nil,
        expected: [
          Tudu::Tasks.new("todos", "task2"),
          Tudu::Tasks.new("todos", "task3"),
          Tudu::Tasks.new("doings", "task1"),
        ]
      },
      {
        case_no: 7,
        case_title: "todos not exists, empty args",
        type: "doings",
        texts: ["task1", "task2", "task3"],
        choose: nil,
        expected: [
          Tudu::Tasks.new("doings", "task1"),
          Tudu::Tasks.new("doings", "task2"),
          Tudu::Tasks.new("doings", "task3"),
        ]
      },

    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          Tudu::Tasks.choose c[:choose]

          # -- then --
          expect(Tudu::Tasks.get_tasks).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Tudu::Core.new.init
        File.open("./#{Tudu::Tasks::TUDU_DIR}/#{c[:type]}", "w") {|f|f.puts c[:texts].join("\n")}
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :done do
    cases = [
      {
        case_no: 1,
        case_title: "one doing to done, shift todo to doing",
        task_names: ["task1", "task2", "task3"],
        choose: "task1",
        expected: [
          Tudu::Tasks.new("todos", "task3"),
          Tudu::Tasks.new("doings", "task2"),
          Tudu::Tasks.new("dones", "task1"),
        ]
      },
      {
        case_no: 2,
        case_title: "one doing to done, not shift todo to doing",
        task_names: ["task1"],
        choose: "task1",
        expected: [
          Tudu::Tasks.new("dones", "task1"),
        ]
      },
      {
        case_no: 3,
        case_title: "no doing",
        task_names: ["task1"],
        choose: "",
        expected: [
          Tudu::Tasks.new("todos", "task1"),
        ]
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          Tudu::Core.new.init
          Tudu::Tasks.add *c[:task_names]
          Tudu::Tasks.choose c[:choose] unless c[:choose].empty?

          # -- when --
          Tudu::Tasks.done

          # -- then --
          expect(Tudu::Tasks.get_tasks).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :add do
    cases = [
      {
        case_no: 1,
        case_title: "single add",
        task_names1: "task_name",
        task_names2: nil,
        task_names3: nil,
        expected: [
          Tudu::Tasks.new("todos", "task_name")
        ]
      },
      {
        case_no: 2,
        case_title: "nil add",
        task_names1: nil,
        task_names2: nil,
        task_names3: nil,
        expected: []
      },
      {
        case_no: 3,
        case_title: "multi add",
        task_names1: "task_name1",
        task_names2: "task_name2",
        task_names3: "task_name3",
        expected: [
          Tudu::Tasks.new("todos", "task_name1"), 
          Tudu::Tasks.new("todos", "task_name2"), 
          Tudu::Tasks.new("todos", "task_name3")
        ]
      },
      {
        case_no: 4,
        case_title: "duplicate add",
        task_names1: "task_name1",
        task_names2: "task_name1",
        task_names3: nil,
        expected: [
          Tudu::Tasks.new("todos", "task_name1"), 
        ]
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          Tudu::Core.new.init

          # -- when --
          actual = Tudu::Tasks.add c[:task_names1], c[:task_names2], c[:task_names3]

          # -- then --
          actual = Tudu::Tasks.get_todos
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end


  context :remove do
    cases = [
      {
        case_no: 1,
        case_title: "single remove",
        add_tasks: ["task_name"],
        remove_tasks: ["task_name"],
        expected_tasks: [],
      },
      {
        case_no: 2,
        case_title: "multi remove",
        add_tasks: ["task_name1", "task_name2", "task_name3"],
        remove_tasks: ["task_name1", "task_name2", "task_name3"],
        expected_tasks: [],
      },
      {
        case_no: 3,
        case_title: "not remove",
        add_tasks: ["task_name"],
        remove_tasks: ["invalid name"],
        expected_tasks: [Tudu::Tasks.new("todos", "task_name")],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          Tudu::Core.new.init
          Tudu::Tasks.add *c[:add_tasks]

          # -- when --
          Tudu::Tasks.remove *c[:remove_tasks]

          # -- then --
          actual = Tudu::Tasks.get_tasks
          expect(actual).to eq(c[:expected_tasks])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exists? Tudu::Tasks::TUDU_DIR
        FileUtils.rm_rf(Tudu::Tasks::TUDU_DIR)
      end
    end
  end

  context :filter_tasks do
    cases = [
      {
        case_no: 1,
        case_title: "get todos from file",
        tasks: [
          Tudu::Tasks.new("doings", "task1_1"),
          Tudu::Tasks.new("doings", "task1_2"),
          Tudu::Tasks.new("doings", "task3"),
          ],
        filter_word: "task1_1",
        expected: [Tudu::Tasks.new("doings", "task1_1")],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          # nothing

          # -- when --
          actual = Tudu::Tasks.filter_tasks(c[:tasks], c[:filter_word])

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
      end
    end
  end
end
