extends Node

var lend_skill: = { "none": 0 }

func use(target: Pawn) -> void:
    match lend_skill:
        #warning-ignore:unassigned_variable
        { "some": var skill }:
            skill.use(target)
            _change_skill(name)
            lend_skill = { "none": 0}
        { "none": 0 }:
            lend_skill = target.skill
            match lend_skill:
                { "some": var skill }:
                    _change_skill(skill.name)
                

func _ready() -> void:
    get_parent().skill = { "some": self }
    _change_skill(name)
    

func _change_skill(text: String) -> void:
    get_parent().get_node("Skill").text = text
