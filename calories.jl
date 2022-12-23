using Printf

##

calories_in = open("in/1a.txt")

elves::Vector{Vector{Int}} = []
basket::Vector{Int} = []

for l in eachline(calories_in)
    if l == "" || eof(calories_in)
        append!(elves, [copy(basket)])
        empty!(basket)      
    else
        append!(basket, parse(Int, l))
    end
end

close(calories_in)

calories_per = sort(sum.(elves), rev=true)

##

@printf "1a: The elf carrying the most calories has %d calories\n" calories_per[1]
@printf "1b: The three elves carrying the most calories have %d calories total\n" sum(calories_per[1:3])
