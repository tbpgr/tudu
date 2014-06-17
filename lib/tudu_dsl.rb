# encoding: utf-8
require 'tudu/version'

module Tudu
  # = Tudu::Dsl
  class Dsl
    # == TARGET_TYPES
    # notice target types
    # === types
    #- none: no notice
    #- mail: mail notice
    TARGET_TYPES = { none: :none, mail: :mail }
    # == notice target type
    attr_accessor :_target_type
    # == notice targets
    attr_accessor :_targets

    # == initialize Dsl
    def initialize
      @_target_type = TARGET_TYPES[:none]
      @_targets = []
    end

    # == initialize Dsl
    # === Params
    #- target_type: target notice type
    def target_type(target_type)
      return if target_type.nil?
      return unless [String, Symbol].include?(target_type.class)
      target_type = target_type.to_sym if target_type.instance_of? String
      return unless TARGET_TYPES.include? target_type
      @_target_type = target_type
    end

    def targets(target_type)
      return if target_type.nil?
      return unless target_type.instance_of? Array
      @_targets = target_type
    end
  end
end
