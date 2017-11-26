#!/usr/bin/ruby
require 'json'

$constants_file_name = "cons.json"
$actions = [
    "generate",
    "step",
    "exhaust",
    "obtain",
    "display",
    "reset",
]
$constants = JSON.parse File.read $constants_file_name
$MAX = $constants['max']
$MIN = $constants['min']
$pool = $constants['pool'].map { |k, v| [k.to_i, v] } .to_h
$DEFAULT_POOL = {
    0 => "z", 1 => "h",
    2 => "hh", 3 => "hhh",
    4 => "hhhh", 5 => "hhhhh",
    7 => "hhhhhhh"
}

def valid_image?(image)
    return image <= $MAX && image >= $MIN
end

def key_by_prefix(options, key)
    if options.include? key
        return key
    end
    
    candidates = options.select { |search|
        search.start_with? key
    }
    
    return nil                  if candidates.empty?
    return candidates.first     if candidates.size == 1
    
    candidates.sort!
    choice = candidates.first
    
    $stderr.puts "Ambiguous referral for #{key.inspect}."
    $stderr.puts "Selected: #{choice.inspect}."
    
    $stderr.puts "Confirm action? (y/n) [y] "
    if $stdin.gets.start_with? "n"
        exit 2
    end
    
    return choice
end

$binary = {
    "t" => lambda { |x, y| x * y },
    "a" => lambda { |x, y| x + y },
    "b" => lambda { |x, y| x / y },
}
$unary = {
    "ha" => lambda { |x| x + 1 },
    "hc" => lambda { |x| x - 1 },
    "dt" => lambda { |x| x * x },
    "da" => lambda { |x| x * 2 },
    "ddaa" => lambda { |x| x * 3 },
}
def step_pool
    res = $pool.clone
    
    $pool.each { |x, repr|
        $unary.each { |fn_repr, fn|
            image = fn[x]
            image_repr = repr + fn_repr
            if valid_image? image
                if res.has_key?(image) && res[image].size <= image_repr.size
                    next
                end
                res[image] = image_repr
            end
        }
    }
    
    $pool = res
end

def update
    $constants['pool'] = $pool
    File.write $constants_file_name, $constants.to_json
end

$option_index = 0
def read_option(title)
    res = if ARGV[$option_index].nil?
        puts title
        $stdin.gets.nil? ? nil : $_.chomp
    else
        ARGV[$option_index]
    end
    $option_index += 1
    res
end

primary_arg = read_option("Enter value for the option:")

if primary_arg.nil?
    $stderr.puts "Error: no option given"
    exit -2
end

input = primary_arg.downcase
action = key_by_prefix($actions, input)

case action
    when nil
        $stderr.puts "Error: #{input.inspect} is not a valid option."
        $stderr.puts "Valid options:"
        $stderr.puts $actions.map { |e| "  #{e}" } .join "\n"
    # when "generate"
    when "obtain"
        option = read_option("Enter the constant to obtain")
        puts "#{$pool[option.to_i]}"
    when "reset"
        $pool = $DEFAULT_POOL
        update
    when "exhaust"
        cover = ($MIN..$MAX).to_a
        while cover.any? { |e| $pool[e].nil? }
            step_pool
        end
        update
    when "step"
        step_pool
        update
    when "display"
        $pool.sort.each { |key, val|
            puts "#{key} -> #{val}"
        }
    else
        $stderr.puts "[DEV] unhandled valid option #{action.inspect}"
        exit -1
end