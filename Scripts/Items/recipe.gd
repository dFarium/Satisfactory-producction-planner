extends Resource
class_name Recipe

enum Building {
	Assembler,
	Blender,
	Constructor,
	Manufacturer,
	Merger,
	Miner,
	NuclearPowerPlant,
	OilExtractor,
	Packager,
	ParticleAccelerator,
	Refinery,
	Smelter,
	Splitter,
	WaterExtractor,
	WellExtractor,
	Foundry,
}

@export var building:Building
@export var name:String
@export var inputs:Array[ItemAmount] = []
@export var outputs:Array[ItemAmount] = []
@export var manufacturing_cycle:float
@export var is_alternate_recipe:bool
