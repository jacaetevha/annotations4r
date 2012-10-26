module Annotations
  class ArityMismatch < ::StandardError; end
  class NoSuchMethodInAncestors < ::StandardError; end

  def override
    @check_method = true
  end

  def singleton_method_added method_name
    check_method(method_name, :class)
  end

  def method_added method_name
    check_method(method_name, :instance)
  end

  def check_method method_name, type
    if @check_method
      clazz = self.ancestors.reject{|e| e == self}.first
      super_method = begin
                       type == :instance ? clazz.instance_method(method_name) : clazz.method(method_name)
                     rescue NameError
                       nil
                     end
      unless super_method
        raise NoSuchMethodInAncestors, "None of #{self}'s ancestors defines ##{method_name}"
      end
      my_method = type == :instance ? self.instance_method(method_name) : self.method(method_name)
      unless super_method.arity == my_method.arity
        raise ArityMismatch, "#{clazz}##{method_name}(#{super_method.arity}) vs. #{self}##{method_name}(#{my_method.arity})"
      end
    end
    @check_method = nil
  end
end
