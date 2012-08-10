require 'cuken/api/aruba'
World(Cuken::Api::Aruba::Api)

# From Jeff Gardner
# http://jeffgardner.org/2011/08/04/rails-string-to-boolean-method/
class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

module ::Cuken
  module Api
    module Common

      def with_args(*args)
        backup = ARGV.dup
        begin
          ARGV.replace(args)
          yield
        rescue Exception => e
          puts e.backtrace.join("\n") if $!.respond_to?(:status) && $!.status && $!.status > 0
        ensure
          ARGV.replace(backup)
        end
      end

      def clone_pull_error_check(res)
        if repo = res[/Could not find Repository /]
          raise RuntimeError, "Could not find Repository #{repo}", caller
        end
        if repo = res[/ERROR: (.*) doesn't exist. Did you enter it correctly?/,1]
          raise RuntimeError, "ERROR: #{repo} doesn't exist. Did you enter it correctly? #{repo}", caller
        end
      end

    end
  end
end

