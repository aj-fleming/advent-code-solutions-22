using Printf
##

# draws are 3 points, wins are 6
# A, B, C -> rock, paper, scissors
# X, Y, Z -> rock, paper, scissors in response
# rock = 1 point, paper = 2 points, scissors = 3 points

# encode which throw wins via getindex
# beats[1] = 3 and so on

loser(a) = getindex([3, 1, 2], a)
winner(a) = getindex([2, 3, 1], a)

wins(a, b) = a == winner(b)
loses(a, b) = a == loser(b)

function wrongstrategy(round)
    theirs, mine = Int.(getindex.(split(round), 1)) .- [64, 87]
    # solve part a
    return mine + 3 * (theirs == mine) + 6*wins(mine, theirs)
end

function rightstrategy(round)
    theirs, mine = Int.(getindex.(split(round), 1)) .- [64, 87]
    score = 0
    if mine == 1 # need to lose
        score += loser(theirs) # points for the losing throw
    elseif mine == 2 # need to draw
        score += 3 + theirs # 3 points for draw + drawing throw
    else # need to win
        score += 6 + winner(theirs) # 6 points for win + winning throw
    end
    return score
end
##

total_score_bad = mapreduce(wrongstrategy, +, eachline("in/2a.txt"))
total_score_good = mapreduce(rightstrategy, +, eachline("in/2a.txt"))

##
@printf "2a: My total score in the tournament (using the strategy guide incorrectly) is %d\n" total_score_bad
@printf "2b: My total score in the tournament (using the guide correctly) is %d\n" total_score_good