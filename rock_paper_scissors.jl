using Printf
##

# draws are 3 points, wins are 6
# A, B, C -> rock, paper, scissors
# X, Y, Z -> rock, paper, scissors in response
# rock = 1 point, paper = 2 points, scissors = 3 points

# encode which throw wins via getindex
# beats[1] = 3 and so on

function wins(a, b) 
    return a == getindex([2, 3, 1], b)
end

##

strategy_in = open("in/2a.txt", "r")

global total_score = 0
for round in eachline(strategy_in)
    theirs, mine = Int.(getindex.(split(round), 1)) .- [64, 87]
    global total_score += mine # add the points for my throw
    if theirs == mine
        total_score += 3 # 3 points for a draw
    elseif wins(mine, theirs)
        total_score += 6
    end
end

close(strategy_in)

##
@printf "2a: My total score in the tournament is %d" total_score