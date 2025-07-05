extends CharacterBody2D

##################################################
const AFTER_IMAGE_SCENE: PackedScene = \
preload("res://scenes/after_image/after_image.tscn")

const MOVING_SPEED = 200.0

@onready var after_images_node = get_tree().root.get_node("Main/AfterImages")

var animated_sprite_node: AnimatedSprite2D
var after_image_timer: float = 0.0
var after_image_interval: float = 0.1
var is_moving: bool = false

##################################################
func _ready() -> void:
	animated_sprite_node = $AnimatedSprite2D
	print(after_images_node)

##################################################
func _physics_process(delta: float) -> void:
	var x_direction: float = Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction * MOVING_SPEED
		if x_direction > 0:
			animated_sprite_node.flip_h = false
		elif x_direction < 0:
			animated_sprite_node.flip_h = true
		animated_sprite_node.play("movement")
	else:
		velocity.x = move_toward(velocity.x, 0, MOVING_SPEED)
	
	var y_direction: float = Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction * MOVING_SPEED
		animated_sprite_node.play("movement")
	else:
		velocity.y = move_toward(velocity.x, 0, MOVING_SPEED)
	
	if not x_direction and not y_direction:
		animated_sprite_node.play("idle")
		is_moving = false
	else:
		is_moving = true

	move_and_slide()

##################################################
func _process(delta: float) -> void:
	after_image_timer += delta
	
	if after_image_timer >= after_image_interval:
		after_image_timer = 0.0
		if is_moving:
			_spawn_afterimage()

##################################################
func _spawn_afterimage() -> void:
	var after_image_instance: Node2D = AFTER_IMAGE_SCENE.instantiate()
	after_image_instance.global_position = global_position + Vector2()
	
	var sprite = after_image_instance.get_node("Sprite2D")
	sprite.texture = \
	animated_sprite_node.sprite_frames.get_frame_texture(animated_sprite_node.animation, animated_sprite_node.frame)
	sprite.flip_h = animated_sprite_node.flip_h
	
	after_images_node.add_child(after_image_instance)
