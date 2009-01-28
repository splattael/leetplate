module Leetplate

  class Finder

    LEET2NUM = {
      "o" => 0,
      "i" => 1,
      "z" => 2,
      "e" => 3,
      "a" => 4,
      "s" => 5,
      "g" => 6,
      #"l" => 7,
      "t" => 7,
      "b" => 8,
      "p" => 9,
    }

    @dicts = []

    def initialize(*dicts)
      @dicts = dicts.map {|d| Dictionary.new(d) }
    end

    def find(prefix, options={})
      regex = /^(#{prefix})([a-z0-9-]{1,2})([#{LEET2NUM.keys.join}]{1,4})$/i

      @dicts.map do |dict|
        find_in_dict(dict, regex)
      end.flatten.compact.uniq.sort
    end

    def find_in_dict(dict, regex)
      results = []
      dict.each do |line|
        line.chomp!
        if m = regex.match(line)
          prefix, mid, leet = m.captures
          code = unleet(leet)
          results << Result.new(prefix, mid, code, line)
        end
      end
      results
    end

    def unleet(str)
      str.split(//).map do |char|
        LEET2NUM[char] || char
      end.join
    end


    class Result < Struct.new(:prefix, :mid, :code, :word)

      include Comparable

      def initialize(*args)
        super
        self.prefix = prefix.upcase
        self.mid = mid.upcase
        self.word = word.downcase
      end

      def to_s
        "%s # %s\n" % [ plate, word ]
      end

      def plate
        "%2s-%2s %-4s" % [ prefix, mid, code ]
      end

      def <=>(other)
        word <=> other.word
      end

    end # Result


    class Dictionary
      include Enumerable

      CACHE = {}

      def initialize(path)
        @path = path
      end

      def each(&block)
        unless @lines = CACHE[@path]
          @lines = CACHE[@path] = File.read(@path)
        end
        @lines.each(&block)
      end

    end # Dictionary

  end # Finder
  
end # Leetplate
 
if $0 == __FILE__
  ARGV.size != 1 and raise "usage: #{$0} prefix"
  include Leetplate
  prefix = ARGV[0]

  DICT = ENV['DICT'] ? ENV['DICT'].split(/ /) : %w(/usr/share/dict/ogerman /usr/share/dict/american-english)

  finder = Finder.new(*DICT)
  finder.find(prefix).each do |result|
    puts result
  end
end
