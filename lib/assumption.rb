require "assumption/version"
require "assumption/result"
require "assumption/invalid_error"
require "assumption/action_controller"

module Assumption; end

class << Assumption
  private

  def assume(params, options)
    lack = verify_including(params, options[:include])
    surplus = verify_excluding(params, options[:exclude])
    Assumption::Result.new(lack, surplus)
  end
  public :assume

  def verify_excluding(params, must_be_excluded)
    case must_be_excluded
    when String, Symbol
      surplus = must_be_excluded if params_to_keys(params).include?(must_be_excluded.to_s)
    when Array
      surplus = must_be_excluded.inject([]) do |_surplus, obj|
        _surplus << verify_excluding(params, obj)
      end.compact
    when Hash
      surplus = {}
      must_be_excluded.each_pair do |key, node|
        next unless params_to_keys(params).include?(key.to_s)

        if result = verify_excluding(params[key], node)
          surplus[key] = result 
        end
      end
    end

    surplus.blank? ? nil : surplus
  end

  def verify_including(params, must_be_included)
    case must_be_included
    when String, Symbol
      lack = must_be_included unless params_to_keys(params).include?(must_be_included.to_s)
    when Array
      lack = must_be_included.inject([]) do |_lack, obj|
        _lack << verify_including(params, obj)
      end.compact
    when Hash
      lack = {}
      must_be_included.each_pair do |key, node|
        unless params_to_keys(params).include?(key.to_s)
          lack[key] = node
          next
        end

        if result = verify_including(params[key], node)
          lack[key] = result
        end
      end
    end
    lack.blank? ? nil : lack
  end

  def params_to_keys(params)
    case params
    when String, Symbol
      [params.to_s]
    when Array
      params.map(&:to_s)
    when Hash
      params.keys.map(&:to_s)
    end
  end
end
