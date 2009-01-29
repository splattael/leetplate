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

    REJECT_MID = %w(hj kz ns sa ss)

    @dicts = []

    def initialize(*dicts)
      @dicts = dicts.map {|d| Dictionary.new(d) }
    end

    def find(prefix, options={})
      leet = LEET2NUM.keys
      leet_wo_o = leet - ["o"]
      @regex = /^(#{prefix})([a-z-]{1,2})([#{leet_wo_o.join}][#{leet.join}]{0,3})$/i
      @dicts.map do |dict|
        find_in_dict(dict)
      end.flatten.compact.uniq.sort
    end

    def find_in_dict(dict)
      results = []
      dict.each do |line|
        line.chomp!
        if m = @regex.match(line)
          prefix, mid, leet = m.captures
          next if reject?(prefix, mid, leet)
          code = unleet(leet)
          results << Result.new(prefix, mid, code, line)
        end
      end
      results
    end

    def reject?(prefix, mid, leet)
      REJECT_MID.include?(mid.downcase)
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
