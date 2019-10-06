extends Node

var astar = AStar.new()
var map_size: = Vector2(64, 64)

func _ready():
    pass # Replace with function body.

func add_unit(coordinate: Vector2) -> void:
    var index: = calculate_point_index(coordinate)
    astar.set_point_disabled(index, true)
    

func remove_unit(coordinate: Vector2) -> void:
    var index: = calculate_point_index(coordinate)
    astar.set_point_disabled(index, false)


func calculate_point_index(point: Vector2) -> float:
    return point.x + map_size.x * point.y


func add_walkable_cells(obstacles := []) -> Array:
    var points: = []
    for y in range(map_size.y):
        for x in range(map_size.x):
            var point: = Vector2(x, y)
            if point in obstacles:
                continue
                
            points.append(point)
            var index: = calculate_point_index(point)
            astar.add_point(index, Vector3(point.x, point.y, 0))
    return points
    
 
func connect_walkable_cells(points: Array) -> void:
    for point in points:
        var index: = calculate_point_index(point)
        var points_relative: = PoolVector2Array([
            Vector2(point.x + 1, point.y),
            Vector2(point.x - 1, point.y),
            Vector2(point.x, point.y + 1),
            Vector2(point.x, point.y - 1),
        ])
        
        for point_relative in points_relative:
            var index_relative: = calculate_point_index(point_relative)

            if is_outside_bounds(point_relative):
                continue    
            if not astar.has_point(index_relative):
                continue
            astar.connect_points(index, index_relative, false)
            
            
func is_outside_bounds(point: Vector2) -> bool:
    return point.x < 0\
        or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y
        

func find_path(start_position: Vector2, end_position: Vector2) -> Array:
#    remove_unit(start_position)
#    remove_unit(end_position)

    var path: = []
    if astar.has_point(calculate_point_index(end_position)):
        var map_path = astar.get_point_path(
            calculate_point_index(start_position),
            calculate_point_index(end_position))
        for point in map_path:
            path.append(point)

#    add_unit(start_position)
#    add_unit(end_position)

    path.pop_front()
    return path
    
    
    
func is_disabled(x: float, y: float) -> bool:
    return is_disabledv(Vector2(x, y))
    
func is_disabledv(point: Vector2) -> bool:
    if is_outside_bounds(point):
        return true

    var index = calculate_point_index(point)
    return !astar.has_point(index) || astar.is_point_disabled(index)
    