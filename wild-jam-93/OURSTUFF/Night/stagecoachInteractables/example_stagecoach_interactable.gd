extends Node2D

#example stagecoach interactable
#these would spawn on the map during night gameplay

@onready var area2d = $Area2D # must be in "StagecoachInteractable" group

func canInteract(stagecoach: Node2D): #check data and return true if all requirments are met 
	var data = stagecoach.getStagecoachData
	if true:
		return true
	else:
		return false

func stagecoachInteract(): # the result of a stagecoach interacting
	pass 
