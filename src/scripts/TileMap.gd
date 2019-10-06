extends TileMap


func _ready() -> void:
    var obstacles: = get_used_cells()
    var cells: Array = Map.add_walkable_cells(obstacles)
    Map.connect_walkable_cells(cells)
    
    for unit in get_children():
        var coordinate: = world_to_map(unit.position)
        unit.position = map_to_world(coordinate)
        Map.add_unit(coordinate)

func find_path(init_position: Vector2, target_position: Vector2) -> Array:
    var start_position: = world_to_map(init_position)
    var end_position: = world_to_map(target_position)

    var path: = Map.find_path(start_position, end_position)
    var world_path: = []
    for point in path:
        var point_world: = map_to_world(Vector2(point.x, point.y))
        world_path.append(point_world)

    return world_path
    

func get_pawn(coordinate: Vector2) -> Dictionary:
    var coord = world_to_map(coordinate)
    for unit in get_children():
        if world_to_map(unit.position) == coord:
            return { "some": unit }
    return { "none": 0 }
