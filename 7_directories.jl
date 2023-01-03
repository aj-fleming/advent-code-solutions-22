using Printf

FileNode = @NamedTuple begin label::String; size::Int end

struct DirectoryNode
    label::AbstractString
    parent::Union{DirectoryNode, Nothing}
    files::Vector{FileNode}
    children::Vector{DirectoryNode}
end

function DirectoryNode(label::AbstractString, parent::Union{DirectoryNode, Nothing})
    return DirectoryNode(label, parent, Vector{FileNode}(undef, 0), Vector{DirectoryNode}(undef, 0))
end

insert_file!(dir::DirectoryNode, f::FileNode) = append!(dir.files, [f])

function insert_child_dir!(dir::DirectoryNode, label::AbstractString)
    newdir = DirectoryNode(label, dir)
    append!(dir.children, [newdir])
end

function fill_directory_tree!(head::DirectoryNode, istream::IOStream)
    cursor = head
    while !eof(istream)
        command = split(readline(istream))
        if command[2] == "cd"
            if command[3] == "/"
                cursor = head
            elseif command[3] == ".."
                cursor = cursor.parent
            else
                for dir in cursor.children
                    if command[3] == dir.label
                        cursor = dir
                        break
                    end
                end
            end
        elseif command[2] == "ls"
            while !eof(istream) && peek(istream, Char) != '$'
                item = split(readline(istream))
                if item[1] == "dir"
                    insert_child_dir!(cursor, item[2])
                else
                    insert_file!(cursor, (label=string(item[2]), size=parse(Int, item[1])))
                end
            end 
        end
    end
end

dirsize(d::DirectoryNode) = mapreduce(dirsize, +, d.children; init=0) + sum([f.size for f in d.files])



root = DirectoryNode("/", nothing)
open("in/7a.txt") do io
    fill_directory_tree!(root, io)
end

function find_all_sizes(tree_root::DirectoryNode)
    result::Vector{Int} = [dirsize(tree_root)]
    if length(tree_root.children) > 0
        append!(result, [find_all_sizes(c) for c in tree_root.children]...)
    end
    return result
end

all_sizes = sort!(find_all_sizes(root))

# solution 7a
sum_of_sizes = sum(filter(s -> s < 100000, all_sizes))
@printf "Sum of directory sizes of at most 100000 is %d\n" sum_of_sizes

disk_space = 70000000
update_size = 30000000
free_space = disk_space - dirsize(root)
free_space_after_delete = free_space .+ all_sizes

viable_dir = findfirst(map(s -> s > update_size, free_space_after_delete))

#solution 7b
@printf "Directory size of smallest directory to delete that allows update is %d\n" all_sizes[viable_dir]