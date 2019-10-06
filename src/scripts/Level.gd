extends Node2D

onready var map = $Foreground

func _ready():
    Events.connect("move", self, "_on_Pawn_move")
    
    for pawn in map.get_children():
        Queue.add(pawn)
    Queue.next_turn()

func _on_Pawn_move(pawn: Node2D, coordinate: Vector2) -> void:
    pawn.move(map.find_path(pawn.position, coordinate))
