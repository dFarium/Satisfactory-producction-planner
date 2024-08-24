using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;

public partial class JsonToResource : Node
{
    public class JsonData
    {
        public string Version { get; set; }
        public JsonItem[] Items { get; set; }
        public JsonRecipe[] Recipes { get; set; }
    }

    public class JsonItem
    {
        public string Name { get; set; }
        public string Icon { get; set; }
    }

    public class JsonRecipe
    {
        public string Name { get; set; }
        public bool Alternate { get; set; }
        public float Time { get; set; }
        public string Building { get; set; }
        public JsonItemAmount[] Inputs { get; set; }
        public JsonItemAmount[] Outputs { get; set; }
    }

    public class JsonItemAmount
    {
        public string Name { get; set; }
        public float Amount { get; set; }
    }

    public JsonRecipe[] LoadRecipesFromJson(string filePath)
    {
        string json = System.IO.File.ReadAllText(filePath);
        JsonData jsonData = JsonConvert.DeserializeObject<JsonData>(json);
        return jsonData.Recipes;
    }

    public List<Item> LoadItems()
    {
        List<Item> items = new List<Item>();
        DirAccess dir = DirAccess.Open("res://Items/");
        dir.ListDirBegin();
        string itemName = dir.GetNext();

        while (itemName != "")
        {
            string itemPath = "res://Items/" + itemName;

            Item item = (Item)ResourceLoader.Load(itemPath);
            if (item == null)
            {
                GD.PrintErr("Error loading item: " + itemName);
            }

            items.Add(item);
            itemName = dir.GetNext();
        }

        return items;
    }

    public void SaveResources()
    {
        List<Item> items = LoadItems();
        List<JsonRecipe> jsonRecipes = LoadRecipesFromJson("D:/!Descargas/recipes.json").ToList();
        int id = 0;
        //Compare items with jsonRecipes items
        foreach (var jsonRecipe in jsonRecipes)
        {
            List<ItemAmount> inputs = new List<ItemAmount>();
            List<ItemAmount> outputs = new List<ItemAmount>();
            foreach (var jsonItemAmount in jsonRecipe.Inputs)
            {
                Item item = items.Find(i => i.Name == jsonItemAmount.Name);
                if (item == null)
                {
                    GD.PrintErr("Item not found: " + jsonItemAmount.Name);
                }

                inputs.Add(new ItemAmount(item, jsonItemAmount.Amount));
            }

            foreach (var jsonItemAmount in jsonRecipe.Outputs)
            {
                Item item = items.Find(i => i.Name == jsonItemAmount.Name);
                if (item == null)
                {
                    GD.PrintErr("Item not found: " + jsonItemAmount.Name);
                }

                outputs.Add(new ItemAmount(item, jsonItemAmount.Amount));
            }

            Recipe recipe = new Recipe(id, jsonRecipe.Name, inputs.ToArray(), outputs.ToArray(), jsonRecipe.Time,
                jsonRecipe.Alternate, StringToEnum(jsonRecipe.Building));
            id++;
            DirAccess dir = DirAccess.Open("res://Recipes/");
            if (!dir.DirExists("res://Recipes/" + recipe.Outputs[0].Item.Name))
            {
                GD.Print("Creating directory: " + recipe.Outputs[0].Item.Name);
                dir.MakeDir("res://Recipes/" + recipe.Outputs[0].Item.Name);
            }

            ResourceSaver.Save(recipe,
                "res://Recipes/" + recipe.Outputs[0].Item.Name + "/" + recipe.Name.ToSnakeCase() + ".tres");
        }
    }

    public  static Recipe.BuildingType StringToEnum(string building)
    {
        return building switch
        {
            "Miner" => Recipe.BuildingType.Miner,
            "Water Extractor" => Recipe.BuildingType.WaterExtractor,
            "Oil Extractor" => Recipe.BuildingType.OilExtractor,
            "Well Extractor" => Recipe.BuildingType.WellExtractor,
            "Smelter" => Recipe.BuildingType.Smelter,
            "Foundry" => Recipe.BuildingType.Foundry,
            "Constructor" => Recipe.BuildingType.Constructor,
            "Assembler" => Recipe.BuildingType.Assembler,
            "Manufacturer" => Recipe.BuildingType.Manufacturer,
            "Packager" => Recipe.BuildingType.Packager,
            "Refinery" => Recipe.BuildingType.Refinery,
            "Blender" => Recipe.BuildingType.Blender,
            "Particle Accelerator" => Recipe.BuildingType.ParticleAccelerator,
            "Biomass Burner" => Recipe.BuildingType.BiomassBurner,
            "Coal Generator" => Recipe.BuildingType.CoalGenerator,
            "Fuel Generator" => Recipe.BuildingType.FuelGenerator,
            "Nuclear Power Plant" => Recipe.BuildingType.NuclearPowerPlant,
            "Awesome Sink" => Recipe.BuildingType.AwesomeSink,
            _ => Recipe.BuildingType.Miner
        };
    }

    public override void _Ready()
    {
        RecipeLoader.LoadRecipes();
    }
}