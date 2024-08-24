using System;
using System.Collections.Generic;
using System.Linq;
using Godot;

[GlobalClass]
public partial class Recipe : Resource
{
    [Export] public int Id { get; set; }
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

    public Recipe() : this(0, "", null, null, 0, false,0)
    {
    }

    public Recipe(int id, string name, ItemAmount[] inputs, ItemAmount[] outputs, float processingTime,
        bool isAlternative,BuildingType buildingType)
    {
        Id = id;
        Name = name;
        Inputs = inputs;
        Outputs = outputs;
        ProcessingTime = processingTime;
        IsAlternative = isAlternative;
        Building = buildingType;
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

    public float GetCyclesPerMin()
    {
        return 60 / ProcessingTime;
    }

    public Item FindBottleNeck(ItemAmount[] inputs)
    {
        var ratios = new List<float>();

        if (inputs.Length != Inputs.Length)
        {
            GD.PrintErr("Not enough inputs to find bottleneck");
            return null;
        }

        for (int i = 0; i < inputs.Length; i++)
        {
            ratios.Add(inputs[i].Amount / Inputs[i].Amount);
        }

        //return the smallest ratio
        return Inputs[ratios.IndexOf(ratios.Min())].Item;
    }

    public Item GetInputItem(int index)
    {
        return Inputs[index].Item;
    }

    public Item GetOutputItem(int index)
    {
        return Outputs[index].Item;
    }

    public float GetItemsPerMin(Item item)
    {
        for (int i = 0; i < Outputs.Length; i++)
        {
            if (Outputs[i].Item == item)
            {
                return Outputs[i].Amount / ProcessingTime * 60;
            }
        }

        return 0;
    }
}