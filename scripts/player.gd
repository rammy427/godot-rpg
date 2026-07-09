class_name Player extends CharacterBody2D

enum Directions {UP, DOWN, LEFT, RIGHT}
signal countered_enemy

@export var charname: String = 'Eros'
@export var speed: float = 200.0
@export var max_health: int = 50
@export var attack: int = 32
@export var defense: int = 24
var health = max_health

var facing: Directions
var isFighting: bool

func _ready():
	var parentName: String = get_parent().name
	isFighting = (parentName == 'battle')
	facing = Directions.RIGHT if isFighting else Directions.DOWN

func _physics_process(_delta: float) -> void:
	if isFighting:
		if Input.is_action_just_pressed('ui_accept'):
			$AnimatedSprite2D.play('side_attack')
			countered_enemy.emit()
	else:
		update_direction()
		move_and_slide()
	
func update_direction() -> void:
	var direction: Vector2
	if isFighting:
		direction = Vector2.ZERO
	else:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if (direction.x < 0):
			facing = Directions.LEFT
		elif (direction.x > 0):
			facing = Directions.RIGHT
		elif (direction.y < 0):
			facing = Directions.UP
		elif (direction.y > 0):
			facing = Directions.DOWN
		velocity = direction * speed
		
	update_anim(direction)
	
func update_anim(direction: Vector2) -> void:
	var anim = $AnimatedSprite2D
	
	# If the character is dead, play the death animation.
	if isDead():
		anim.play('death')
		return
	
	# Always flip the character when facing left.
	anim.flip_h = (facing == Directions.LEFT)
	
	# Character is moving.
	if (direction):
		if (facing == Directions.UP):
			anim.play('back_walk')
		elif (facing == Directions.DOWN):
			anim.play('front_walk')
		else:
			anim.play('side_walk')
	# Character is idle.
	else:
		if (facing == Directions.UP):
			anim.play('back_idle')
		elif (facing == Directions.DOWN):
			anim.play('front_idle')
		else:
			anim.play('side_idle')

func executeBattleAction(target: Enemy) -> void:
	var dmg = max(1, randi_range(attack, 2 * attack) - target.defense)
	target.health = max(0, target.health - dmg)
	print(charname, ' deals ', dmg, ' damage to ', target.charname)
	
func isDead() -> bool:
	return health <= 0
