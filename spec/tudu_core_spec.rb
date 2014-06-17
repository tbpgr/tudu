# encoding: utf-8
require 'spec_helper'
require 'tudu_core'
require 'tudu_paths'
require 'tudu_templates'
require 'tasks'

describe Tudu::Core do
  context :init do
    cases = [
      {
        case_no: 1,
        case_title: 'valid case',
        expected_files: [
          Tudu::TuduPaths::TUDU_FILE,
          Tudu::TuduPaths::TUDU_TODOS_FILE,
          Tudu::TuduPaths::TUDU_DOINGS_FILE,
          Tudu::TuduPaths::TUDU_DONES_FILE
        ],
        expected_contents: [
          Tudu::Templates::TUDU_FILE_TEMPLATE,
          Tudu::Templates::TUDU_TODOS_FILE_TEMPLATE,
          Tudu::Templates::TUDU_DOINGS_FILE_TEMPLATE,
          Tudu::Templates::TUDU_DONES_FILE_TEMPLATE
        ],
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new

          # -- when --
          tudu_core.init

          # -- then --
          c[:expected_files].each_with_index do |file_name, index|
            actual = File.open("./tudu/#{file_name}") { |f|f.read }
            expect(actual).to eq(c[:expected_contents][index])
          end
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :add do
    cases = [
      {
        case_no: 1,
        case_title: 'single add',
        task_names1: 'task_name',
        task_names2: nil,
        task_names3: nil,
        expected: ['task_name']
      },
      {
        case_no: 2,
        case_title: 'nil add',
        task_names1: nil,
        task_names2: nil,
        task_names3: nil,
        expected: []
      },
      {
        case_no: 3,
        case_title: 'multi add',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        expected: %w(task_name1 task_name2 task_name3)
      },
      {
        case_no: 4,
        case_title: 'duplicate add',
        task_names1: 'task_name1',
        task_names2: 'task_name1',
        task_names3: nil,
        expected: ['task_name1']
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init

          # -- when --
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3]

          # -- then --
          actual = File.read('./tudu/todos').split("\n")
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :remove do
    cases = [
      {
        case_no: 1,
        case_title: 'single remove',
        task_names1: 'task_name',
        task_names2: nil,
        task_names3: nil,
      },
      {
        case_no: 2,
        case_title: 'multi remove',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
      },
      {
        case_no: 3,
        case_title: 'not remove',
        task_names1: 'invalid name',
        task_names2: nil,
        task_names3: nil,
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3]

          # -- when --
          tudu_core.remove c[:task_names1], c[:task_names2], c[:task_names3]

          # -- then --
          [c[:task_names1], c[:task_names2], c[:task_names3]].each do |e|
            actual = false
            %w(./tudu/todos ./tudu/doings ./tudu/dones).each do |f|
              actual = true if File.read(f).split("\n").include?(e)
            end
            expect(actual).to be_false
          end
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :tasks do
    cases = [
      {
        case_no: 1,
        case_title: '[todos, dosings, dones] all tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        search_word: nil,
        expected: %w(task_name1 task_name2 task_name3)
      },
      {
        case_no: 2,
        case_title: '[todos, dosings, dones] search specific tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        search_word: 'task_name1',
        expected: ['task_name1']
      },
      {
        case_no: 3,
        case_title: '[todos, dosings, dones] search specific tasks by regexp',
        task_names1: 'task_name1_1',
        task_names2: 'task_name2_1',
        task_names3: 'task_name2_2',
        task_names4: 'task_name3_1',
        search_word: 'task_name2_',
        expected: %w(task_name2_1 task_name2_2)
      },
      {
        case_no: 4,
        case_title: '[todos, dosings, dones] all tasks with category option',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        search_word: nil,
        options: { category: true },
        expected: [
          '========TODOS========',
          'task_name1',
          'task_name2',
          'task_name3',
          '========DOINGS========',
          '========DONES========',
        ]
      },
      {
        case_no: 5,
        case_title: '[todos, dosings, dones] all tasks with category option, color option',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        search_word: nil,
        choose_cnt: 1,
        done_cnt: 1,
        options: { category: true, color: true },
        expected: [
          '========TODOS========',
          "\e[31mtask_name3\e[0m",
          '========DOINGS========',
          "\e[33mtask_name2\e[0m",
          '========DONES========',
          "\e[36mtask_name1\e[0m",
        ]
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3], c[:task_names4]
          c[:choose_cnt].times { tudu_core.choose nil } if c[:choose_cnt]
          c[:done_cnt].times { tudu_core.done } if c[:done_cnt]

          # -- when --
          actual = tudu_core.tasks c[:search_word], c[:options]

          # -- then --
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :todos do
    cases = [
      {
        case_no: 1,
        case_title: 'todos all tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose: true,
        choose_name: 'task_name1',
        search_word: nil,
        expected: %w(task_name2 task_name3)
      },
      {
        case_no: 2,
        case_title: 'todos search specific tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose: true,
        choose_name: 'task_name1',
        search_word: 'task_name3',
        expected: ['task_name3']
      },
      {
        case_no: 3,
        case_title: 'todos search specific tasks by regexp',
        task_names1: 'task_name1_1',
        task_names2: 'task_name2_1',
        task_names3: 'task_name2_2',
        task_names4: 'task_name3_1',
        choose: true,
        choose_name: 'task_name1_1',
        search_word: 'task_name2_',
        expected: %w(task_name2_1 task_name2_2)
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3], c[:task_names4]
          tudu_core.choose(c[:choose_name]) if c[:choose]

          # -- when --
          actual = tudu_core.todos c[:search_word]

          # -- then --
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :doings do
    cases = [
      {
        case_no: 1,
        case_title: 'doings all tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose: true,
        choose_name: 'task_name1',
        search_word: nil,
        expected: ['task_name1']
      },
      {
        case_no: 2,
        case_title: 'doings search specific tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose: true,
        choose_name: 'task_name1',
        search_word: nil,
        expected: ['task_name1']
      },
      {
        case_no: 3,
        case_title: 'doings search specific tasks by regexp',
        task_names1: 'task_name1_1',
        task_names2: 'task_name2_1',
        task_names3: 'task_name2_2',
        task_names4: 'task_name3_1',
        choose: true,
        choose_name: 'task_name1_1',
        search_word: 'task_name1_',
        expected: ['task_name1_1']
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3], c[:task_names4]
          tudu_core.choose(c[:choose_name]) if c[:choose]

          # -- when --
          actual = tudu_core.doings c[:search_word]

          # -- then --
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :dones do
    cases = [
      {
        case_no: 1,
        case_title: 'doings all tasks',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose_names: %w(task_name1 task_name2),
        done_names: ['task_name1'],
        search_word: nil,
        expected: ['task_name1']
      },
      {
        case_no: 2,
        case_title: 'doings search specific tasks',
        task_names1: 'task_name1_1',
        task_names2: 'task_name1_2',
        task_names3: 'task_name2_1',
        choose_names: %w(task_name1_1 task_name1_2 task_name2_1),
        done_names: %w(task_name1_1 task_name1_2 task_name2_1),
        search_word: 'task_name1_',
        expected: %w(task_name1_1 task_name1_2)
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3], c[:task_names4]
          c[:choose_names].each do |e|
            tudu_core.choose e
            tudu_core.done if c[:done_names].include? e
          end

          # -- when --
          actual = tudu_core.dones c[:search_word]

          # -- then --
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :choose do
    cases = [
      {
        case_no: 1,
        case_title: 'choose task',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose: 'task_name1',
        expected_todos: "task_name2\ntask_name3\n",
        expected_doings: "task_name1\n"
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3]

          # -- when --
          tudu_core.choose c[:choose]

          # -- then --
          actual_doings = File.read("./tudu/#{Tudu::TuduPaths::TUDU_DOINGS_FILE}")
          expect(actual_doings).to eq(c[:expected_doings])
          actual_todos = File.read("./tudu/#{Tudu::TuduPaths::TUDU_TODOS_FILE}")
          expect(actual_todos).to eq(c[:expected_todos])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end

  context :done do
    cases = [
      {
        case_no: 1,
        case_title: 'one doing to done, shift todo to doing',
        task_names1: 'task_name1',
        task_names2: 'task_name2',
        task_names3: 'task_name3',
        choose: 'task_name1',
        expected_doings: "task_name2\n",
        expected_done: "task_name1\n"
      },
      {
        case_no: 2,
        case_title: 'one doing to done, not shift todo to doing',
        task_names1: 'task_name1',
        choose: 'task_name1',
        expected_doings: '',
        expected_done: "task_name1\n"
      },
      {
        case_no: 3,
        case_title: 'no doing',
        task_names1: 'task_name1',
        choose: '',
        expected_doings: '',
        expected_done: ''
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_core = Tudu::Core.new
          tudu_core.init
          tudu_core.add c[:task_names1], c[:task_names2], c[:task_names3]
          tudu_core.choose c[:choose] unless c[:choose].empty?

          # -- when --
          tudu_core.done

          # -- then --
          actual_doings = File.read(Tudu::TuduPaths::TUDU_DOINGS_FILE_PATH)
          expect(actual_doings).to eq(c[:expected_doings])
          actual_dones = File.read(Tudu::TuduPaths::TUDU_DONES_FILE_PATH)
          expect(actual_dones).to eq(c[:expected_done])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        return unless File.exist? './tudu'
        FileUtils.rm_rf('./tudu')
      end
    end
  end
end
