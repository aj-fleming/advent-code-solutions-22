using Printf

trees = reduce(hcat, permutedims(map(eachline("in/8a.txt")) do line
    map(collect(line)) do c
        parse(Int, c)
    end
end))

function update_visibility_LR!(vis_slice, tree_slice)
    largest_tree = -1
    for i=axes(vis_slice, 1)
        if tree_slice[i] <= largest_tree
            vis_slice[i] -= 1
        else
            largest_tree = tree_slice[i]
        end
    end
    
    largest_tree = -1
    for i=reverse(axes(vis_slice, 1))
        if tree_slice[i] <= largest_tree
            vis_slice[i] -= 1
        else
            largest_tree = tree_slice[i]
        end
    end
end

function find_visibility(trees)
    visible_directions = fill(4, size(trees))

    for i=axes(visible_directions, 1)
        update_visibility_LR!(view(visible_directions, i, :), view(trees, i, :))
    end

    for i=axes(visible_directions, 2)
        update_visibility_LR!(view(visible_directions, :, i), view(trees, :, i))
    end

    return visible_directions
end

visible_trees = find_visibility(trees)
@printf "Number of visible trees is %d\n" sum(map(>(0), visible_trees))

function scenic_score(trees)
    scores = fill(0, size(trees))
    for i in 2:size(trees, 1)-1, j in 2:size(trees, 2)-1
        scoreU = 0
        for k in i-1:-1:1
            scoreU += 1
            trees[k, j] >= trees[i,j] && break
        end
        scoreD = 0
        for k in i+1:size(trees, 1)
            scoreD += 1
            trees[k, j] >= trees[i,j] && break
        end
        scoreL = 0
        for k in j-1:-1:1
            scoreL += 1
            trees[i,k] >= trees[i,j] && break
        end
        scoreR = 0
        for k in j+1:size(trees, 2)
            scoreR += 1
            trees[i,k] >= trees[i,j] && break
        end
        scores[i,j] = scoreU * scoreD * scoreR * scoreL
    end
    return scores
end

@printf "The score of the spot for the best tree is %d\n" maximum(scenic_score(trees))