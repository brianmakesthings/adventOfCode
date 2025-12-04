# frozen_string_literal: true

data = File.read("./input.txt")

def part1(data)
  workflow_input, ratings_input = data.split("\n\n")
  workflow = parse_workflow(workflow_input)
  ratings = parse_ratings(ratings_input)
  result = ratings.map do |rating|
    is_accepted = evaluate_rating(workflow, rating) == "A"
    if is_accepted
      rating.values.sum
    else
      0
    end
  end.sum
  puts result
end

def parse_workflow(workflow_input)
  result = {}
  workflow_input.split("\n").each do |line|
    name, rules = line.split("{")
    rules = rules[0...-1]
    steps = rules.split(",")
    result[name] = parse_steps(steps)
  end
  result
end

def parse_steps(steps)
  steps.map do |step|
    next(->(_) { step }) unless step.include?(":")

    condition, output = step.split(":")
    if condition.include?("<")
      value, comparator = condition.split("<")
      comparator = Integer(comparator)
      ->(val_map) { output if val_map.fetch(value) < comparator }
    elsif condition.include?(">")
      value, comparator = condition.split(">")
      comparator = Integer(comparator)
      ->(val_map) { output if val_map.fetch(value) > comparator }
    else
      binding.irb
      raise
    end
  end
end

def parse_ratings(ratings_input)
  ratings_input.split("\n").map do |line|
    res = {}
    line[1...-1].split(",").each do |assignment|
      key, value = assignment.split("=")
      res[key] = Integer(value)
    end
    res
  end
end

def evaluate_rating(workflow, rating)
  stage = "in"
  while stage != "R" && stage != "A"
    conditions = workflow[stage]
    conditions.each do |condition|
      next_stage = condition.call(rating)

      next if next_stage.nil?

      stage = next_stage
      break
    end
  end
  stage
end

def part2(data)
  workflow_input, _ = data.split("\n\n")
  workflow = parse_workflow_array(workflow_input)
  puts workflow
end

def parse_workflow_array(workflow_input)
  result = {}
  workflow_input.split("\n").each do |line|
    name, rules = line.split("{")
    rules = rules[0...-1]
    steps = rules.split(",")
    result[name] = parse_steps_array(steps)
  end
  result
end

def parse_steps_array(steps)
  steps.map do |step|
    next(["default", step]) unless step.include?(":")

    condition, output = step.split(":")
    if condition.include?("<")
      value, comparator = condition.split("<")
      comparator = Integer(comparator)
      ["<", value, comparator]
    elsif condition.include?(">")
      value, comparator = condition.split(">")
      comparator = Integer(comparator)
      [">", value, comparator]
    else
      binding.irb
      raise
    end
  end
end

test_data =
  <<~TEXT
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
  TEXT

# part1(test_data)
# part1(data)
part2(test_data)
# part2(data)
