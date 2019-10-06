extends Node

var is_active: = false setget _set_active


func _set_active(value: bool) -> void:
    is_active = value
    if is_active:
        Events.emit_signal("change_walking_area",
            { "show": get_parent().position, "steps": get_parent().steps })
    else:
        Events.emit_signal("change_walking_area", { "clear": 0 })


func _input(event: InputEvent) -> void:
    if not is_active || Queue.active_unit != get_parent():
        return

    if event is InputEventMouseButton and event.pressed:
        Events.emit_signal("click", get_parent(), event.position)


func _ready() -> void:
    if get_parent().connect("idle", self, "_on_Pawn_idle"):
        print(name + " cannot see, if pawn is idle")
    if get_parent().connect("busy", self, "_on_Pawn_busy"):
        print(name + " cannot see, if pawn is busy")
    

func _on_Pawn_idle() -> void:
    _set_active(true)
    

func _on_Pawn_busy() -> void:
    _set_active(false)
    