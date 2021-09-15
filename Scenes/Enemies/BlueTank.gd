extends PathFollow2D

var speed = 150

func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta: float) -> void:
	set_offset(get_offset() + speed * delta)
