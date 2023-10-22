extends CharacterBody2D
class_name Player

const SPEED = 9000.0

@onready var animation_player = $AnimationPlayer
@onready var ray_cast_2d = $RayCast2D
@onready var audio_stream = $AudioStream

signal life_changed(life: float)
signal dead()

@export var max_life := 100.0
@export var life := 100.0:
  set (value):
    if value < life and not audio_stream.playing:
      audio_stream.play()
    if life != value:
      life = clamp(value, 0.0, max_life)
      life_changed.emit(life)
      if life <= 0.0:
        dead.emit()
  get:
    return life


func _physics_process(delta):
  var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  velocity = direction * SPEED * delta
  move_and_slide()

  var is_moving = velocity != Vector2.ZERO
  if is_moving:
    rotation = Vector2.RIGHT.angle_to(velocity)
  if not is_moving and animation_player.current_animation != "idle":
    animation_player.play("idle")
  elif is_moving and animation_player.current_animation != "run":
    animation_player.play("run")

  if Input.is_action_just_pressed("ui_accept"):
    ray_cast_2d.force_raycast_update()
    var object = ray_cast_2d.get_collider()
    if object != null:
      object.action()
