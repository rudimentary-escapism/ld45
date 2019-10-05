extends TileMap

var astar = AStar.new()

export (Vector2) var map_size: = Vector2(64, 64)

#func convert_coordinate(coordinate: Vector2) -> Vector2:
#    var temp = world_to_map(coordinate)
#    return map_to_world(temp)


func _ready() -> void:
    var obstacles: = get_used_cells()
    var cells: = astar_add_walkable_cells(obstacles)
    astar_connect_walkable_cells(cells)
    

func astar_add_walkable_cells(obstacles := []) -> Array:
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


func calculate_point_index(point: Vector2) -> float:
    return point.x + map_size.x * point.y
    
    
func astar_connect_walkable_cells(points: Array) -> void:
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

            if is_outside_map_bounds(point_relative):
                continue    
            if not astar.has_point(index_relative):
                continue
            astar.connect_points(index, index_relative, false)
            
            
func is_outside_map_bounds(point: Vector2) -> bool:
    return point.x < 0\
        or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func find_path(init_position: Vector2, target_position: Vector2) -> Array:
    var start_position: = world_to_map(init_position)
    var end_position: = world_to_map(target_position)

#    remove_unit_from_map(start_position)
#    remove_unit_from_map(end_position)

    var world_path: = []
    if astar.has_point(calculate_point_index(end_position)):
        var map_path = astar.get_point_path(
            calculate_point_index(start_position),
            calculate_point_index(end_position))
        for point in map_path:
            var point_world: = map_to_world(Vector2(point.x, point.y))
            world_path.append(point_world)

#    add_unit_to_map(start_position)
#    add_unit_to_map(end_position)

    world_path.pop_front()
    return world_path
