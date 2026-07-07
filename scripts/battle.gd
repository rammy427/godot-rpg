extends Node2D

@export var player: Player
@export var enemy: Enemy

var isPlayerTurn: bool = true
var display_health: Label
var isGameOver: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $player
	enemy = $enemy
	var display_name = $Menu/MenuItems/PlayerInfo/Player1/Name
	display_health = $Menu/MenuItems/PlayerInfo/Player1/Health
	display_name.text = player.charname
	updateHealth()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not isGameOver:
		if not isPlayerTurn:
			enemy.executeBattleAction(player, delta)
			if player.isDead():
				isGameOver = true
		
		updateHealth()

func _on_attack_pressed() -> void:
	if isPlayerTurn:
		player.executeBattleAction(enemy)
		isPlayerTurn = false

func updateHealth() -> void:
	display_health.text = var_to_str(player.health) + '/' + var_to_str(player.max_health)

func _on_enemy_battle_action_completed() -> void:
	isPlayerTurn = true
