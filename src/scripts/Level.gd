extends Node2D

onready var map = $Foreground

func _ready():
    if Events.connect("click", self, "_on_Pawn_click"):
        print(name + " cannot see, if user clicks")
    if Events.connect("mouse_motion", self, "_on_Pawn_mouse_motion"):
        print(name + " cannot see, if user mouse is moved")
    
    for pawn in map.get_children():
        Queue.add(pawn)
    Queue.next_turn()

func _on_Pawn_click(pawn: Node2D, coordinate: Vector2) -> void:
    match map.get_pawn(coordinate):
        #warning-ignore:unassigned_variable
        { "some": var unit }:
            if unit != pawn:
                match get_attack_path(pawn, unit):
                    #warning-ignore:unassigned_variable
                    { "some": var path }:
                        pawn.attack(unit)
        { "none": 0 }:
            pawn.move(map.find_path(pawn.position, coordinate))
            
func _on_Pawn_mouse_motion(pawn: Node2D, coordinate: Vector2) -> void:
    $WalkingArea.visible = true
    var area = $AttackArea
    area.clear()
    match map.get_pawn(coordinate):
        #warning-ignore:unassigned_variable
        { "some": var unit }:
            if unit != pawn:
                match get_attack_path(pawn, unit):
                    #warning-ignore:unassigned_variable
                    { "some": var path }:
                        $WalkingArea.visible = false
                        for point in path:
                            area.set_cellv(point, 0)
    

func get_attack_path(pawn: Pawn, target: Pawn) -> Dictionary:
    var area = $AttackArea
    var from = area.world_to_map(pawn.position)
    var to = area.world_to_map(target.position)
    var path = pawn.get_attack_path(from, to)
    for point in path:
        if Map.is_disabledv(point):
            return { "none": 0 }
    return { "some": path }
