# encoding: utf-8
require "tudu/version"

module Tudu
  #= Tudu::Dsl
  class Dsl
    #== TARGET_TYPES
    # notice target types
    #=== types
    #- none: no notice
    #- mail: mail notice
    TARGET_TYPES = {:none => :none, :mail => :mail}
    #== notice target type
    attr_accessor :_target_type
    #== notice targets
    attr_accessor :_targets

    #== initialize Dsl 
    def initialize
      @_target_type = TARGET_TYPES[:none]
      @_targets = []
    end

    #== initialize Dsl 
    #=== Params
    #- _target_type: target notice type
    def target_type(_target_type)
      return if _target_type.nil?
      return unless _target_type.instance_of? String or _target_type.instance_of? Symbol
      _target_type = _target_type.to_sym if _target_type.instance_of? String
      return unless TARGET_TYPES.include? _target_type
      @_target_type = _target_type
    end

    def targets(_targets)
      return if _targets.nil?
      return unless _targets.instance_of? Array
      @_targets = _targets
    end
  end
end
