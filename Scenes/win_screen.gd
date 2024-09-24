extends CanvasLayer

var total = 100
var killed = 50
var donefor = 0
var percentage := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if total > 0:
		percentage = (killed / total) * 100
		print(killed / total)
		$Label.text = str(percentage) + "%"
	else:
		$Label.text = "N/A"  # Handle the case where total is 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
