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

    def one_arg_instance_method one
      'one_arg_instance_method: ' + one.to_s
    end

    def two_arg_instance_method one, two
      'two_arg_instance_method: ' + one.to_s + ', ' + two.to_s
    end
  end

  context "overrides" do
    before :each do
      @class_factory = lambda{|method|
        args = 
          case method
          when /one_arg/
            @match_arity ? "one" : ""
          when /two_arg/
            @match_arity ? "one, two" :  "one"
          else
            @match_arity ? "" : "one"
          end
        Class.new(A) do
          extend Annotations
          override
          if method =~ /clazz/
            instance_eval "def #{method}(#{args}); super; end"
          else
            class_eval "def #{method}(#{args}); super; end"
          end
        end
      }
    end

    it "raises ArityMismatch" do
      @match_arity = false
      expect { @class_factory['no_arg_clazz_method'] }.to raise_error(Annotations::ArityMismatch)
      expect { @class_factory['one_arg_clazz_method'] }.to raise_error(Annotations::ArityMismatch)
      expect { @class_factory['two_arg_clazz_method'] }.to raise_error(Annotations::ArityMismatch)
      expect { @class_factory['no_arg_instance_method'] }.to raise_error(Annotations::ArityMismatch)
      expect { @class_factory['one_arg_instance_method'] }.to raise_error(Annotations::ArityMismatch)
      expect { @class_factory['two_arg_instance_method'] }.to raise_error(Annotations::ArityMismatch)
    end

    it "doesn't raise ArityMismatch" do
      @match_arity = true
      expect { @class_factory['no_arg_clazz_method'] }.not_to raise_error
      expect { @class_factory['one_arg_clazz_method'] }.not_to raise_error
      expect { @class_factory['two_arg_clazz_method'] }.not_to raise_error
      expect { @class_factory['no_arg_instance_method'] }.not_to raise_error
      expect { @class_factory['one_arg_instance_method'] }.not_to raise_error
      expect { @class_factory['two_arg_instance_method'] }.not_to raise_error
    end

    it "raises NoSuchMethodInAncestors" do
      @match_arity = true
      expect { @class_factory['no_super_clazz_method'] }.to raise_error(Annotations::NoSuchMethodInAncestors)
      expect { @class_factory['no_super_instance_method'] }.to raise_error(Annotations::NoSuchMethodInAncestors)
      @match_arity = false
      expect { @class_factory['no_super_clazz_method'] }.to raise_error(Annotations::NoSuchMethodInAncestors)
      expect { @class_factory['no_super_instance_method'] }.to raise_error(Annotations::NoSuchMethodInAncestors)
    end
  end

end
