module PgSearch
  class Configuration
    class JsonbColumn < PlainColumn
      def initialize(name, *keys)
        super(name)
        raise ArgumentError, 'At least one key is required' if keys.nil? || keys.length == 0
        @keys = keys.map(&:to_s)
      end

      def to_sql(connection, *)
        quoted_keys = @keys.map { |k| connection.quote(k) }
        path = quoted_keys[0..-2].join('->')
        super + (path != '' && "->#{path}" || '') + "->>#{quoted_keys.last}"
      end
    end
  end
end
