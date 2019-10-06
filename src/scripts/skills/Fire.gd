extends Node

func use(target: Pawn) -> void:
    target.damage(1)
                
func _ready() -> void:
    get_parent().skill = { "some": self }
    get_parent().get_node("Skill").text = name 
