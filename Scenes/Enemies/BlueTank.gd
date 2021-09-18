extends PathFollow2D

var speed: int = 150
var hp: float = 50

onready var health_bar: TextureProgress = $HealthBar

func _ready() -> void:
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta: float) -> void:
	set_offset(get_offset() + speed * delta)
	health_bar.set_position(position - Vector2(30,30))

func on_hit(damage: int) -> void:
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func on_destroy() -> void:
	queue_free()
