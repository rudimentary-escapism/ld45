extends Node2D

onready var map = $Foreground

func _ready():
    if Events.connect("click", self, "_on_Pawn_click"):
        print("Cannot see, if user clicks")
    
    for pawn in map.get_children():
        Queue.add(pawn)
    Queue.next_turn()

func _on_Pawn_click(pawn: Node2D, coordinate: Vector2) -> void:
    match map.get_pawn(coordinate):
        #warning-ignore:unassigned_variable
        { "some": var unit }:
            if unit != pawn:
                pawn.attack(unit)
        { "none": 0 }:
            pawn.move(map.find_path(pawn.position, coordinate))
