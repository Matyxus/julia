module TravelingSalesman
using JSON
# Write your package code here.

export greet, greet2, load_data, distance_matrix

greet() = print("Hello World!")
greet2() = print("Hello World!!!!")

const CWD = pwd()
const DATA_PATH = CWD * "\\Data"
const JSON_EXTENSION = ".json"


function load_data(file_name::String)::Union{Nothing, Dict}
    # Move to "data" folder and add extension
    file_name = DATA_PATH * "\\" * file_name * JSON_EXTENSION
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
    println("Making distance matrix of $(cities)")
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

end
