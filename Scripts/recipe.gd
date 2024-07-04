extends Resource
class_name Recipe

@export var name:String
@export var inputs:Array[ItemAmount] = []
@export var outputs:Array[ItemAmount] = []
@export var manufacturing_cycle:float
@export var is_alternate_recipe:bool
