extends StaticBody2D
class_name Switch

@export var on := false

signal activated()

func _ready():
  $AnimationPlayer.play("on" if on else "off")


func enable(value: bool):
  if on == value:
    return
  on = value
  $AnimationPlayer.play("on" if on else "off")


func action():
  if not on:
    return
  $AnimationPlayer.play("active")
  activated.emit()
