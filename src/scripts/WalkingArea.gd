extends TileMap


func _ready() -> void:
    if Events.connect("change_walking_area", self, "_on_change"):
        print("Can't connect change_walking_area")


func _on_change(msg) -> void:
    match msg:
        #warning-ignore:unassigned_variable
        #warning-ignore:unassigned_variable
        { "show": var pos, "steps": var steps }:
            show_walking_area(world_to_map(pos), steps)
        { "clear": 0 }:
            clear()
    
            
func show_walking_area(pos: Vector2, max_steps: int) -> void:
    show_walking_cell(pos, Vector2.UP, max_steps, 1)
    show_walking_cell(pos, Vector2.DOWN, max_steps, 1)
    show_walking_cell(pos, Vector2.LEFT, max_steps, 1)
    show_walking_cell(pos, Vector2.RIGHT, max_steps, 1)
        

func show_walking_cell(pos: Vector2, dir: Vector2, steps: int, step: int) -> void:
    if step > steps:
        return
        
    var new_pos = pos + dir
    if Map.is_disabledv(new_pos):
        return

    var path = Map.find_path(pos, new_pos)
    if len(path) > steps:
        return
        
    set_cell(int(new_pos.x), int(new_pos.y), 0)
        
    if dir != Vector2.UP:
        show_walking_cell(new_pos, Vector2.DOWN, steps, step + 1)
    if dir != Vector2.DOWN:
        show_walking_cell(new_pos, Vector2.UP, steps, step + 1)
    if dir != Vector2.LEFT:
        show_walking_cell(new_pos, Vector2.RIGHT, steps, step + 1)
    if dir != Vector2.RIGHT:
        show_walking_cell(new_pos, Vector2.LEFT, steps, step + 1)
