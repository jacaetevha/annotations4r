module Annotations
  class ArityMismatch < ::StandardError; end
  
  def override
    @check_method = true
  end

  def singleton_method_added method_name
    if @check_method
      clazz = self.ancestors.reject{|e| e == self}.first
      unless clazz.methods.include? method_name
        raise "None of #{self}'s ancestors defines ##{method_name}"
      end
      super_method = clazz.method method_name
      my_method = self.method method_name
      unless super_method.arity == my_method.arity
        raise ArityMismatch, "#{clazz}>>##{method_name}(#{super_method.arity}) vs. #{self}>>##{method_name}(#{my_method.arity})"
      end
    end
    @check_method = false
  end

  def method_added method_name
    if @check_method
      clazz = self.ancestors.reject{|e| e == self}.first
      unless clazz.instance_methods.include? method_name
        raise "None of #{self}'s ancestors defines ##{method_name}"
      end
      super_method = clazz.instance_method method_name
      my_method = self.instance_method method_name
      unless super_method.arity == my_method.arity
        raise ArityMismatch, "#{clazz}##{method_name}(#{super_method.arity}) vs. #{self}##{method_name}(#{my_method.arity})"
      end
    end
    @check_method = nil
  end
end
