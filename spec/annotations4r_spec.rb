require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Annotations4r" do
  class A
    def self.no_arg_clazz_method
      'no_arg_clazz_method'
    end
    
    def self.one_arg_clazz_method one
      'one_arg_clazz_method: ' + one.to_s
    end
    
    def self.two_arg_clazz_method one, two
      'two_arg_clazz_method: ' + one.to_s + ', ' + two.to_s
    end
    
    def no_arg_instance_method
      'no_arg_instance_method'
    end
    
    def self.one_arg_instance_method one
      'one_arg_instance_method: ' + one.to_s
    end
    
    def self.two_arg_instance_method one, two
      'two_arg_instance_method: ' + one.to_s + ', ' + two.to_s
    end
  end
    
  context "improper overrides" do
    it "raises ArityMismatch" do
      expects {
        Class.new(A) do
          include Annotations

          override
          def self.two_arg_clazz_method one
            super(one, 2)
          end
        end
      }.to raise_error(Annotations::ArityMismatch)
    end
  end
end
