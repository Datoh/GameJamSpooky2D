extends PointLight2D
class_name Light

@export var on := false
@export var timer := 10.0

signal toggled(on: bool)

func _ready():
  $NavigationObstacle2D.avoidance_enabled = on
  $NavigationObstacle2D.radius *= scale.x
  visible = on


func enable(value):
  if value == on:
    return
  on = value
  if on:
    toggled.emit(true)
  $AnimationPlayer.play("on" if on else "hard_off")
  if not on or timer < 0:
    return
  get_tree().create_timer(timer - 0.4).connect("timeout",
    func():
      if not on:
        return
      on = false
      $AnimationPlayer.play("off")
      toggled.emit(false)
  )

