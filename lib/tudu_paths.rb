# encoding: utf-8
require 'tudu_file_keys'

module Tudu
  # = Tudu::TuduPaths
  module TuduPaths
    # == Tudufile file name
    TUDU_FILE = 'Tudufile'
    # == Tudufile file name
    TUDU_DIR = 'tudu'
    # == todo file name
    TUDU_TODOS_FILE = 'todos'
    # == todo file path
    TUDU_TODOS_FILE_PATH = "./#{TUDU_DIR}/#{TUDU_TODOS_FILE}"
    # == doing file name
    TUDU_DOINGS_FILE = 'doings'
    # == doing file path
    TUDU_DOINGS_FILE_PATH = "./#{TUDU_DIR}/#{TUDU_DOINGS_FILE}"
    # == done file name
    TUDU_DONES_FILE = 'dones'
    # == done file path
    TUDU_DONES_FILE_PATH = "./#{TUDU_DIR}/#{TUDU_DONES_FILE}"
    # == file names
    INIT_FILES = {
      TuduFileKeys::TUDU_FILE_KEY => TUDU_FILE,
      TuduFileKeys::TUDU_TODO_KEY => TUDU_TODOS_FILE,
      TuduFileKeys::TUDU_DOING_KEY => TUDU_DOINGS_FILE,
      TuduFileKeys::TUDU_DONE_KEY => TUDU_DONES_FILE
    }
    # == task file names
    TASK_FILES = {
      TuduFileKeys::TUDU_TODO_KEY => TUDU_TODOS_FILE,
      TuduFileKeys::TUDU_DOING_KEY => TUDU_DOINGS_FILE,
      TuduFileKeys::TUDU_DONE_KEY => TUDU_DONES_FILE
    }
  end
end
