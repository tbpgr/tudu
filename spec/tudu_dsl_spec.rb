# encoding: utf-8
require "spec_helper"
require "tudu_dsl"

describe Tudu::Dsl do
  context :target_type do
    cases = [
      {
        case_no: 1,
        case_title: "valid type String",
        input_type: "mail",
        expected: :mail
      },
      {
        case_no: 2,
        case_title: "valid type Symbol",
        input_type: :mail,
        expected: :mail
      },
      {
        case_no: 3,
        case_title: "invalid type nil",
        input_type: nil,
        expected: :none
      },
      {
        case_no: 4,
        case_title: "invalid type not Symbol or String",
        input_type: 123,
        expected: :none
      },
      {
        case_no: 5,
        case_title: "invalid type",
        input_type: :invalid,
        expected: :none
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_dsl = Tudu::Dsl.new

          # -- when --
          tudu_dsl.target_type c[:input_type]

          # -- then --
          actual = tudu_dsl._target_type
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
      end
    end
  end

  context :targets do
    cases = [
      {
        case_no: 1,
        case_title: "valid type Array",
        input_type: ["tbpgr@tbpgr.jp", "tbpgr@tbpgr.jp"],
        expected: ["tbpgr@tbpgr.jp", "tbpgr@tbpgr.jp"]
      },
      {
        case_no: 2,
        case_title: "invalid type",
        input_type: "tbpgr@tbpgr.jp",
        expected: []
      },
      {
        case_no: 3,
        case_title: "invalid type nil",
        input_type: nil,
        expected: []
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          tudu_dsl = Tudu::Dsl.new

          # -- when --
          tudu_dsl.targets c[:input_type]

          # -- then --
          actual = tudu_dsl._targets
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
      end
    end
  end

end
