# Credit: ActiveSupport v5.1.4

#--
# Most objects are cloneable, but not all. For example you can't dup methods:
#
#   method(:puts).dup # => TypeError: allocator undefined for Method
#
# Classes may signal their instances are not duplicable removing +dup+/+clone+
# or raising exceptions from them. So, to dup an arbitrary object you normally
# use an optimistic approach and are ready to catch an exception, say:
#
#   arbitrary_object.dup rescue object
#
# Rails dups objects in a few critical spots where they are not that arbitrary.
# That rescue is very expensive (like 40 times slower than a predicate), and it
# is often triggered.
#
# That's why we hardcode the following cases and check duplicable? instead of
# using that rescue idiom.
#++
class Object
  # Can you safely dup this object?
  #
  # False for method objects;
  # true otherwise.
  def duplicable?
    true
  end
end

class NilClass
    # +nil+ is not duplicable:
    #
    #   nil.duplicable? # => false
    #   nil.dup         # => TypeError: can't dup NilClass
    def duplicable?
      false
    end
end

class FalseClass
    # +false+ is not duplicable:
    #
    #   false.duplicable? # => false
    #   false.dup         # => TypeError: can't dup FalseClass
    def duplicable?
      false
    end
end

class TrueClass
    # +true+ is not duplicable:
    #
    #   true.duplicable? # => false
    #   true.dup         # => TypeError: can't dup TrueClass
    def duplicable?
      false
    end
end

class Symbol
    # Symbols are not duplicable:
    #
    #   :my_symbol.duplicable? # => false
    #   :my_symbol.dup         # => TypeError: can't dup Symbol
    def duplicable?
      false
    end
end

class Numeric
    # Numbers are not duplicable:
    #
    #  3.duplicable? # => false
    #  3.dup         # => TypeError: can't dup Integer
    def duplicable?
      false
    end
end

require "bigdecimal"
class BigDecimal
  # BigDecimals are duplicable:
  #
  # BigDecimal.new("1.2").duplicable? # => true
  # BigDecimal.new("1.2").dup         # => #<BigDecimal:...,'0.12E1',18(18)>
  def duplicable?
    true
  end
end

class Method
  # Methods are not duplicable:
  #
  #  method(:puts).duplicable? # => false
  #  method(:puts).dup         # => TypeError: allocator undefined for Method
  def duplicable?
    false
  end
end

class Complex
    # Complexes are not duplicable for RUBY_VERSION < 2.5.0:
    #
    # Complex(1).duplicable? # => false
    # Complex(1).dup         # => TypeError: can't copy Complex
    def duplicable?
      false
    end
end

class Rational
    # Rationals are not duplicable for RUBY_VERSION < 2.5.0:
    #
    # Rational(1).duplicable? # => false
    # Rational(1).dup         # => TypeError: can't copy Rational
    def duplicable?
      false
    end
end

class Object
  # Returns a deep copy of object if it's duplicable. If it's
  # not duplicable, returns +self+.
  #
  #   object = Object.new
  #   dup    = object.deep_dup
  #   dup.instance_variable_set(:@a, 1)
  #
  #   object.instance_variable_defined?(:@a) # => false
  #   dup.instance_variable_defined?(:@a)    # => true
  def deep_dup
    duplicable? ? dup : self
  end
end

class Array
  # Returns a deep copy of array.
  #
  #   array = [1, [2, 3]]
  #   dup   = array.deep_dup
  #   dup[1][2] = 4
  #
  #   array[1][2] # => nil
  #   dup[1][2]   # => 4
  def deep_dup
    map(&:deep_dup)
  end
end

class Hash
  # Returns a deep copy of hash.
  #
  #   hash = { a: { b: 'b' } }
  #   dup  = hash.deep_dup
  #   dup[:a][:c] = 'c'
  #
  #   hash[:a][:c] # => nil
  #   dup[:a][:c]  # => "c"
  def deep_dup
    hash = dup
    each_pair do |key, value|
      if key.frozen? && ::String === key
        hash[key] = value.deep_dup
      else
        hash.delete(key)
        hash[key.deep_dup] = value.deep_dup
      end
    end
    hash
  end
end
