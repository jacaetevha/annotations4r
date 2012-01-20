Why?
=======
Why have annotations in Ruby? Well, just because you can. We don't want to get to a Java-luted state with it, but the question was brought up on LinkedIn (http://tinyurl.com/7l3u6mr) and I decided to try a simple implementation. Who knows? It could be useful sometime down the road.

Example
=======
```ruby
$:.unshift '.'
require 'annotate'

class A
  def initialize num
    @num = num
  end
  
  def number
    @num
  end

  def self.with num
    self.new num
  end
end

begin
class B < A
  extend Annotations

  override
  def self.with
    self.new [1,2]
  end
end
rescue
  puts "Example B:\n#{$!.message}\n\n"
end

begin
class C < A
  extend Annotations
  override
  def self.not num
    self.new num
  end
end
rescue
  puts "Example C:\n#{$!.message}\n\n"
end

begin
class D < A
  extend Annotations
  def initialize
    super 2
  end

  def one
    1
  end

  override
  def two
    2
  end
end
rescue
  puts "Example D:\n#{$!.message}\n\n"
end

begin
class E < A
  extend Annotations
  override
  def number num
    num
  end
end
rescue
  puts "Example E:\n#{$!.message}\n\n"
end
```
