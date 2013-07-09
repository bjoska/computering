require "io/console"

module Programming
  class Cmd
    include Programming::Dsl

    CONTROL_C = 3
    ENTER     = 13

    def initialize(file, stdin = STDIN, stdout = STDOUT)
      @file   = file
      @stdin  = stdin
      @stdout = stdout
      @code   = File.readlines(file).join "\n"

      instance_eval @code
    end

    def execute
      items.each do |item|
        if item.blank?
          @stdout.puts ""
        else
          readchars item
        end
      end
    end

    def readchars(item)
      i = 0
      @stdin.noecho do |io|
        while char = io.getch
          return if char.ord == CONTROL_C
          if char.ord == ENTER
            @stdout.puts item[i..-1]
            @stdout.puts item.buffer
            break
          else
            @stdout.putc item[i] if item[i]
            i += 1
          end
        end
      end
    end
  end
end
