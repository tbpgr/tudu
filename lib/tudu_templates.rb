# encoding: utf-8
require 'tudu_file_keys'

module Tudu
  # = Tudu::Templates
  module Templates
    # == Tudufile file template
    TUDU_FILE_TEMPLATE = <<-EOS
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

    # == todo file template
    TUDU_TODOS_FILE_TEMPLATE = ''
    # == doing file template
    TUDU_DOINGS_FILE_TEMPLATE = ''
    # == done file template
    TUDU_DONES_FILE_TEMPLATE = ''

    # == template files
    INIT_FILES_TEMPLATE = {
      TuduFileKeys::TUDU_FILE_KEY => TUDU_FILE_TEMPLATE,
      TuduFileKeys::TUDU_TODO_KEY => TUDU_TODOS_FILE_TEMPLATE,
      TuduFileKeys::TUDU_DOING_KEY => TUDU_DOINGS_FILE_TEMPLATE,
      TuduFileKeys::TUDU_DONE_KEY => TUDU_DONES_FILE_TEMPLATE
    }
  end
end
