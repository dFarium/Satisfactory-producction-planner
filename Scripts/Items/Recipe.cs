using Godot;

[GlobalClass]
public partial class Recipe : Resource
{
    [Export] public BuildingType Building { get; set; }
    [Export] public string Name { get; set; }
    [Export] public ItemAmount[] Inputs { get; set; }
    [Export] public ItemAmount[] Outputs { get; set; }
    [Export] public float ProcessingTime { get; set; }
    [Export] public bool IsAlternative { get; set; }
    public enum BuildingType
    {
        Miner,
        WaterExtractor,
        OilExtractor,
        WellExtractor,
        Smelter,
        Foundry,
        Constructor,
        Assembler,
        Manufacturer,
        Packager,
        Refinery,
        Blender,
        ParticleAccelerator,
        BiomassBurner,
        CoalGenerator,
        FuelGenerator,
        NuclearPowerPlant,
        AwesomeSink,
    }
    public Recipe() : this("", null, null, 0, false)
    {
    }

    public Recipe(string name, ItemAmount[] inputs, ItemAmount[] outputs, float processingTime, bool isAlternative)
    {
        Name = name;
        Inputs = inputs;
        Outputs = outputs;
        ProcessingTime = processingTime;
        IsAlternative = isAlternative;
    }

    public string GetBuildingType()
    {
        return Building switch
        {
            BuildingType.Miner => "Miner",
            BuildingType.WaterExtractor => "Water Extractor",
            BuildingType.OilExtractor => "Oil Extractor",
            BuildingType.WellExtractor => "Well Extractor",
            BuildingType.Smelter => "Smelter",
            BuildingType.Foundry => "Foundry",
            BuildingType.Constructor => "Constructor",
            BuildingType.Assembler => "Assembler",
            BuildingType.Manufacturer => "Manufacturer",
            BuildingType.Packager => "Packager",
            BuildingType.Refinery => "Refinery",
            BuildingType.Blender => "Blender",
            BuildingType.ParticleAccelerator => "Particle Accelerator",
            BuildingType.BiomassBurner => "Biomass Burner",
            BuildingType.CoalGenerator => "Coal Generator",
            BuildingType.FuelGenerator => "Fuel Generator",
            BuildingType.NuclearPowerPlant => "Nuclear Power Plant",
            BuildingType.AwesomeSink => "Awesome Sink",
            _ => "Unknown Building"
        };
    }
}