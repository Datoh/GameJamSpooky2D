extends CharacterBody2D
class_name Spectre

const SPEED = 5000.0
const ROTATION_STEP := 2.0 * PI

@export var follow: Node2D = null
@export var damage: float = 10.0

@onready var navigation_agent = $NavigationAgent2D
@onready var audio_stream = $AudioStream

var rng = RandomNumberGenerator.new()


signal body_entered(spectre: Spectre, body: Player)
signal body_exited(spectre: Spectre, body: Player)

func _ready():
  var delay = rng.randf_range(5.0, 10.0)
  get_tree().create_timer(delay).connect("timeout", func(): _play_sound())


func _physics_process(delta):
  if follow == null:
    return

  navigation_agent.target_position = follow.global_position
  if navigation_agent.is_navigation_finished():
    return


  var next_path_position = navigation_agent.get_next_path_position()
  navigation_agent.set_velocity((next_path_position - global_position).normalized() * delta * SPEED)

  move_and_slide()

  if velocity != Vector2.ZERO:
    rotation = lerp(rotation, Vector2.RIGHT.angle_to(velocity), delta * ROTATION_STEP)


func _on_navigation_agent_velocity_computed(safe_velocity):
  velocity = safe_velocity


func _on_body_entered(body: Node2D):
  if body is Player:
    body_entered.emit(self, body)


func _on_body_exited(body):
  if body is Player:
    body_exited.emit(self, body)


func _play_sound():
  audio_stream.play()
  var delay = rng.randf_range(5.0, 10.0)
  get_tree().create_timer(delay).connect("timeout", func(): _play_sound())
