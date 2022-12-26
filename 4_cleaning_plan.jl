using Printf

rangecontains(a, b) = first(b) in a && last(b) in a
rangeoverlaps(a, b) = first(a) in b || last(a) in b
assignment_to_range(str) = range(parse.(Int, split(str, "-"))...)

function does_full_overlap(line)
    a1, a2 = assignment_to_range.(split(line, ","))
    return rangecontains(a1, a2) || rangecontains(a2, a1)
end

function does_part_overlap(line)
    a1, a2 = assignment_to_range.(split(line, ","))
    return rangeoverlaps(a1, a2) || rangeoverlaps(a2, a1)
end

# solve part a
number_full_overlaps = mapreduce(does_full_overlap, +, eachline("in/4a.txt"))
number_part_overlaps = mapreduce(does_part_overlap, +, eachline("in/4a.txt"))


@printf "Number of plans where one elf's assigned work is totally contained in their partner's is %d\n" number_full_overlaps
@printf "Number of plans where one elf's assigned work is partially contained in their partner's is %d\n" number_part_overlaps