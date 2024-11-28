extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene : PackedScene
@export var playtime = 30
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		c.hide()
	$CoinPrepTimer.start()
		
func spawn_obstacles():
	var max_obstacles = (screensize.x + screensize.y) / 200
	var min_obstacles = max_obstacles / 2
	for i in randi_range(min_obstacles, max_obstacles):
		var c: Area2D = cactus_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		c.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$Player.can_get_hurt = false
	$CactusPrepTimer.start()
	spawn_obstacles()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.start()
		
		
func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()
func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)

func game_over():
	playing = false
	$GameTimer.stop()
	$CactusPrepTimer.stop()
	$Player.die()
	$EndSound.play()
	await $HUD.show_game_over()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$Player.hide()
	
func _on_hud_start_game():
	new_game()

func reset():
	$Player.hide()


func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))


func _on_cactus_prep_timer_timeout() -> void:
	for child in get_children():
		if child.is_in_group("obstacles"):
			child.can_hurt = true
			child.show()
	$Player.can_get_hurt = true


func _on_coin_prep_timer_timeout() -> void:
	for child in get_children():
		if child.is_in_group("coins"):
			child.show()
