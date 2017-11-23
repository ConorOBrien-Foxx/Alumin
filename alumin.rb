#!/bin/ruby
require 'io/console'
class Alumin
    def initialize(cmds)
        @cmds = cmds.gsub(/[^a-z\s]/, "").scan(/h+|./)
        @i = 0
        @stack = []
        @stack_stack = []
    end
    
    attr_reader :i, :stack, :cmds
    
    def run
        while @cmds[@i]
            interpret @cmds[@i]
            @i += 1
        end
    end
    
    def interpret(c)
        case c[0]
            when "a"
                @stack.push @stack.pop + @stack.pop
            when "b"
                top, sec = @stack.pop(2)
                @stack.push top % sec
            when "c"
                top, sec = @stack.pop(2)
                @stack.push top - sec
            when "d"
                @stack.push @stack[-1]
            when "e"
                @stack.push @stack.pop == @stack.pop ? 1 : 0
            when "f"
                cmd = ""
                loop {
                    if @cmds[@i += 1] == "f"
                        break
                    end
                    cmd += @cmds[@i]
                }
                @stack = [@stack.inject(@stack.pop) { |x, y|
                    sub = Alumin.new(cmd)
                    sub.stack.push x, y
                    sub.run
                    sub.stack[-1]
                }]
            when "g"
                top = @stack.pop
                sec = @stack.pop
                @stack.push sec / top
            when "h"
                @stack.push c.size
            when "i"
                @stack.push STDIN.getc.ord
            when "j"
                @stack.push STDIN.gets.to_i
            when "k"
                @stack.pop
            when "l"
                @stack.push @stack.size
            when "m"
                cmd = ""
                loop {
                    if @cmds[@i += 1] == "m"
                        break
                    end
                    cmd += @cmds[@i]
                }
                @stack.map! { |el|
                    sub = Alumin.new(cmd)
                    sub.stack.push el
                    sub.run
                    sub.stack[-1]
                }
            when "n"
                print @stack.pop
            when "o"
                print @stack.pop.chr
            when "p"
                unless @stack[-1] <= 0
                    depth = 0
                    loop {
                        depth -= 1 if cmds[@i] == "q"
                        depth += 1 if cmds[@i] == "p"
                        @i -= 1
                        break if depth == 0
                    }
                end
            when "q"
                if @stack[-1] <= 0
                    depth = 0
                    loop {
                        depth += 1 if cmds[@i] == "q"
                        depth -= 1 if cmds[@i] == "p"
                        @i += 1
                        break if depth == 0
                    }
                end
            when "r"
                @stack.reverse
            when "s"
                @stack.concat @stack_stack.pop
            when "t"
                @stack.push @stack.pop * @stack.pop
            when "u"
                @stack.push @stack.pop(2).max
            when "v"
                @stack.push @stack.pop(2).min
            when "w"
                new_stack = @stack.pop @stack.pop
                @stack_stack.push @stack.clone
                @stack = new_stack
            when "x"
                @stack.push rand @stack.pop
            when "y"
                @stack.push *@stack.pop(2).reverse
            when "z"
                @stack.push 0
        end
    end
end
inst = Alumin.new($<.read)
inst.run
puts inst.stack