module TravelingSalesman
import Random
using JSON
# Write your package code here.
# include("Constants.jl")

export greet, load_data, distance_matrix, Child, GN, initialize_algorithm, step



greet() = print("Hello World!")
temp2() = println("Hello")

const CWD = pwd()
const SEP = Base.Filesystem.pathsep()
const DATA_PATH = CWD * SEP * "Data"
const JSON_EXTENSION = ".json"


function load_data(file_name::String)::Union{Nothing, Dict}
    # Move to "data" folder and add extension
    file_name = (DATA_PATH * SEP * file_name * JSON_EXTENSION)
    # Check file existence
    if !isfile(file_name)
        println("File: '$(file_name)' does not exist!")
        return nothing
    end
    return JSON.parsefile(file_name)
end

"""
    distance_matrix(cities::Dict)::Union{Nothing, Dict{String, Dict{String, Float32}}}

Compute the euclidean distance between each city.

If `cities` is empty, or less than 2, returns `nothing`.

# Examples
```julia-repl
julia> distance_matrix(Dict{String, Any}("c" => Any[1, 8], "b" => Any[4, 1], "a" => Any[1, 2]))

Dict{String, Dict{String, Float32}} with 3 entries:
  "c" => Dict("c"=>0.0, "b"=>7.616, "a"=>6.0)
  "b" => Dict("c"=>7.616, "b"=>0.0, "a"=>3.162)
  "a" => Dict("c"=>6.0, "b"=>3.162, "a"=>0.0)
```
"""
function distance_matrix(cities::Dict)::Union{Nothing, Dict{String, Dict{String, Float32}}}
    if isempty(cities)
        println("Cities are empy!")
        return nothing
    end

    # Calculate (euclidean) distance between two points
    function get_distance(city_1::Vector, city_2::Vector)::Float32
        return round(sqrt((city_2[1] - city_1[1])^2 + (city_2[2] - city_1[2])^2); digits=3)
    end

    city_names::Vector{String} = collect(keys(cities)) # Vector of all city names
    # Check amount of cities
    if length(city_names) < 2
        println("There must be at least 2 cities, got: $(length(city_names)) !")
        return nothing
    end
    # Dictionary mapping distances between cities
    distances::Dict{String, Dict{String, Float32}} = Dict()
    # Construct distance mapping
    for (city_name, distance) in cities
        distances[city_name] = Dict()
        for other_city in city_names
            distances[city_name][other_city] = get_distance(distance, cities[other_city])
        end
    end
    return distances
end

# Structure holding the data of current child, functions to make crossover happen, mutation, ..

# Parent type of algortihm
abstract type Algorithm end

get_params(algorithm::Algorithm)::Dict = algorithm.params
get_matrix_distance(algorithm::Algorithm)::Dict{String, Dict{String, Float32}} = algorithm.distance_matrix


function initialize_algorithm(alg::Algorithm, data::Dict)::Nothing
    # Check initialization
    if isa(alg, Nothing)
        println("Algorithm was not initialized!")
        return nothing
    elseif isempty(data)
        println("Data variable is empty!")
        return nothing
    end
    println("Setting seed to $(data["params"]["seed"])")
    Random.seed!(data["params"]["seed"])
    # Add default parameters
    alg.params = data["params"]
    alg.distance_matrix = distance_matrix(data["cities"])
    # Initialize specific parameters based on chosen algorithm
    return initialize(alg)
end

# Child of genetic algorithm
struct Child
    cities::Vector{String}
end

function mutate(child::Child)::Nothing
    # Check
    if isa(child, Nothing)
        println("Child was not initialized!")
        return nothing
    elseif isempty(child.cities)
        println("Child does not have any route!")
        return nothing
    end
    # Since TravelingSalesman problem has constraint of having each city appear only once,
    # we can just swap randomly two cities to perform mutation
    index1::Int, index2::Int = rand(1, length(child.cities)), rand(1, length(child.cities))
    element1::String = child.cities[index1]
    child.cities[index1] = child.cities[index2]
    child.cities[index2] = element1
    return nothing
end

# Genetic algorithm
mutable struct GN <: Algorithm
    params::Union{Dict, Nothing}
    distance_matrix::Union{Dict{String, Dict{String, Float32}}, Nothing} # Distance matrix 
    selection::Union{Vector{String}, Nothing} # Only cities used to create children (excludes initial city)
    children::Union{Vector{Child}, Nothing} # Children of current step, contain routes (all routes start & end at initial city)
    GN() = new((nothing for _ in 1:length(fieldnames(GN)))...) # Empty constructor
end


function initialize(algorithm::GN)::Nothing
    println("Initializing Genetic Algorithm")
    temp::Vector{String} = collect(keys(algorithm.distance_matrix))
    deleteat!(temp, findall(x->x==algorithm.params["start"], temp)) # Remove initial city (since all children must start & end there)
    algorithm.selection = temp
    # Randomly initialize children -> shuffle paths ("step 0")
    algorithm.children = [Child(Random.shuffle(temp)) for _ in 1:algorithm.params["population"]]
    println("Children: $(algorithm.children)")
    return nothing
end


function step(algorithm::GN)::Union{Pair{Vector{String}, Float32}, Nothing}
    println("Performing step function on Genetic Algorithm")
    # Check
    if isempty(algorithm.children)
        println("Algorithm 'GN' was not initialized!")
        return nothing
    end
    # Rank current children, perform mutation and crossover

    return nothing
end


end
