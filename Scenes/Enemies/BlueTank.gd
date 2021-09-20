extends PathFollow2D

var speed: int = 150
var hp: float = 200

onready var health_bar: TextureProgress = $HealthBar
onready var impact_area: Position2D = $Impact
onready var kinematic_body: KinematicBody2D = $KinematicBody2D

var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")

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
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func impact() -> void:
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instance()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy() -> void:
	kinematic_body.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
