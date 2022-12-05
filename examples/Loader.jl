using Revise # this must come before `using ImageInspector`
using TravelingSalesman
using JSON

greet()

json_file = load_data("temp")
matrix = distance_matrix(json_file["cities"])
