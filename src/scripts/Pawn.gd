extends Node2D
class_name Pawn

onready var tween: Tween = $Tween

export (int) var hp: = 5
export (int) var max_steps := 3
export (int) var steps_per_turn := 2

var steps := 0 setget set_steps
var is_action: = false
var skill = { "none": 0 }


func start_turn() -> void:
    set_steps(steps + steps_per_turn)
    

func set_steps(new_steps: int) -> void:
    steps = max_steps if new_steps > max_steps else new_steps
    $Steps.text = "steps: " + str(steps)
    if steps < 1:
        Events.emit_signal("turn_ended")


func move(path: Array) -> void:
    if is_action:
        return

    is_action = true
    for point in path:
        if steps == 0:
            break
        step(point)
        yield(tween, "tween_all_completed")
        set_steps(steps - 1)
    is_action = false


func step(point: Vector2) -> void:
    if tween.interpolate_property(self, "position", position,
        point, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT) and tween.start():
        return
    position = point
    

func attack(pawn: Pawn) -> void:
    if steps == 0 or is_action:
        return
    match skill:
        #warning-ignore:unassigned_variable
        { "some": var _skill}:
            _skill.use(pawn)
            yield(get_tree().create_timer(0.1), "timeout")
            set_steps(steps - 1)
    
    
func damage(damage: int) -> void:
    hp -= damage
    $HP.text = str(hp)
    if hp < 1:
        queue_free()
        

func _ready():
    $HP.text = str(hp)