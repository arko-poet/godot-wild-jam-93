extends Node2D

#example stagecoach interactable
#these would spawn on the map during night gameplay

@onready var area2d = $Area2D # must be in "StagecoachInteractable" group

func canInteract(stagecoach: Node2D): #check data and return true if all requirments are met 
	var data = stagecoach.getStagecoachData()
	if true:
		return true
	else:
		return false

func getInteractableData():
	return {} # this returns a dictionary of relevent data, like how long it takes to inteact, chance to take damage etc

func stagecoachInteractStart(): # the result of a stagecoach interacting
	pass 

func stagecoachInteractComplete(): # called when stagecoach finishes interaciton timer
	pass 

func stopDecayTimer(): #called when a dispatch happens, other wise you can dispactch a coach to a interactable that becomes null
	pass
