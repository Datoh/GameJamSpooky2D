extends Node2D
class_name LightsGroup

@export var enabled: bool = false

@export var start_light: Light = null
@export var switch: Switch = null
@export var lights_path: Node2D = null
@export var oscillo_cpu: OscilloCPU = null
@export var oscillo_light: Light = null
@export var next_lights_group: LightsGroup = null

var _lights : Array[Light] = []
var _current_light : Light = null

signal display_oscillo(context: LightsGroup, correct_values: Array, values: Array)

func _ready():
  assert(start_light != null)
  assert(oscillo_light != null)
  assert(switch != null)
  assert(lights_path != null)
  assert(oscillo_cpu != null)

  oscillo_cpu.display_oscillo.connect(_on_display_oscillo)
  switch.activated.connect(_on_switch_activated)
  for child in lights_path.get_children():
    if child is Light:
      var light := child as Light
      light.toggled.connect(_on_toggled_next_light_in_path)


func enable(value: bool):
  start_light.enable(value)
  switch.enable(value)
  _turn_off_lights()


func oscillo_ok():
  _turn_off_lights()
  if next_lights_group != null:
    next_lights_group.enable(true)


func _turn_off_lights():
  for light in _lights:
    light.enable(false)
  if _current_light != null:
    _current_light.enable(false)


func _on_switch_activated():
  _turn_off_lights()

  _lights.clear()
  for child in lights_path.get_children():
    if child is Light:
      _lights.append(child)
      child.visible = false
  if _lights.size() > 1:
    for index in range(_lights.size() - 2, -1, -1):
      _lights.append(_lights[index])
  _on_toggled_next_light_in_path(false)


func _on_toggled_next_light_in_path(value: bool):
  if value:
    return
  if _current_light == oscillo_light:
    oscillo_cpu.enable(false, 0.0)

  _current_light = _lights.pop_front()
  if _current_light == null:
    switch.enable(true)
  else:
    _current_light.enable(true)

  if _current_light == oscillo_light:
    oscillo_cpu.enable(true, oscillo_light.timer)


func _on_display_oscillo(correct_values: Array, values: Array):
  display_oscillo.emit(self, correct_values, values)
