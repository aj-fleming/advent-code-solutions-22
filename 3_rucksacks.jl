using Printf

function findshared(bag::Vector{Char})
    pivot = Int(length(bag)/2)
    mistake = intersect(bag[1:pivot], bag[pivot+1:end])
    return mistake[1]
end


prio(c) = Int(c + 58*('A' <= c <= 'Z') - 96)

# solution to part a
prio_sum = sum([prio(findshared(collect(s))) for s in eachline("in/3a.txt")])
badge_sum = mapreduce(prio, +, begin
        in_bags = open("in/3a.txt")
        badges::Vector{Char} = []
        while !eof(in_bags)
            group = reduce(intersect, [collect(readline(in_bags)) for i=1:3])
            append!(badges, group)
        end
        close(in_bags)
        badges
    end)
# to part b

@printf "3a: Priority sum for misplaced items in each rucksack is %d\n" prio_sum
@printf "3b: Priority sum for the badge stickers is %d\n" badge_sum 