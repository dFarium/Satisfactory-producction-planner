using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using Godot.Collections;

public partial class Planner : GraphEdit
{
    private PackedScene _oneInputOneOutput;
    private PackedScene _oneInputTwoOutput;
    private PackedScene _twoInputOneOutput;
    private PackedScene _threeInputOneOutput;
    private PackedScene _fourInputOneOutput;
    private PackedScene _oneOutput;
    private PackedScene _twoInputTwoOutput;
    private PackedScene _fourInputTwoOutput;
    private PackedScene _threeInputTwoOutput;
    private SearchPanel _searchPanelInstance;
    [Export] private RecipeList _recipeList;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _recipeList.Recipes = SetItemIds(_recipeList.Recipes);
        ConnectionRequest += OnConnectionRequest;
        DisconnectionRequest += OnDisconnectionRequest;
        LoadBuildings();
        _searchPanelInstance =
            (SearchPanel)ResourceLoader.Load<PackedScene>("res://Scenes/search_recipe.tscn").Instantiate();
        _searchPanelInstance.RecipeList = _recipeList.Recipes.ToList();
        _searchPanelInstance.PanelDisabled += OnPanelDisabled;
        _searchPanelInstance.AddBuilding += OnAddBuilding;
        AddChild(_searchPanelInstance);
        RemoveChild(_searchPanelInstance);
    }


    private void OnConnectionRequest(StringName fromNode, long fromPort, StringName toNode, long toPort)
    {
        ConnectNode(fromNode, (int)fromPort, toNode, (int)toPort);
        Building building = GetNode<Building>(toNode.ToString());
        foreach (Dictionary connection in GetConnectionList())
        {
            if ((string)connection["to_node"] == toNode.ToString())
            {
                building.Connections.Add(new Connection(fromNode, (int)fromPort, toNode, (int)toPort));
                GD.Print(building.Connections.Count);
            }
        }
    }

    private void OnDisconnectionRequest(StringName fromNode, long fromPort, StringName toNode, long toPort)
    {
        DisconnectNode(fromNode, (int)fromPort, toNode, (int)toPort);
        Building building = GetNode<Building>(toNode.ToString());
        foreach (Dictionary connection in GetConnectionList())
        {
            if ((string)connection["to_node"] == toNode.ToString())
            {
                building.Connections.Remove(new Connection(fromNode, (int)fromPort, toNode, (int)toPort));
                GD.Print(building.Connections.Count);
            }
        }
    }


    public void LoadBuildings()
    {
        _oneInputOneOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/1input1output.tscn");
        _oneInputTwoOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/1input2output.tscn");
        _twoInputOneOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/2input1output.tscn");
        _threeInputOneOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/3input1output.tscn");
        _fourInputOneOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/4input1output.tscn");
        _oneOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/1output.tscn");
        _twoInputTwoOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/2input2output.tscn");
        _fourInputTwoOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/4input2output.tscn");
        _threeInputTwoOutput = ResourceLoader.Load<PackedScene>("res://Scenes/Factories/3input2output.tscn");
    }

    public override void _Input(InputEvent inputEvent)
    {
        if (!Input.IsActionJustPressed("right_click")) return;
        ShowSearchPanel();
    }

    private void ShowSearchPanel()
    {
        foreach (Node child in GetChildren())
        {
            if (child.HasMethod("DeselectBuilding"))
            {
                child.Call("DeselectBuilding");
            }
        }

        if (!_searchPanelInstance.Enabled)
        {
            AddChild(_searchPanelInstance);
            _searchPanelInstance.EnablePanel();
        }

        Vector2 mousePosition = (GetGlobalMousePosition() + ScrollOffset) / Zoom;
        //Snap the panel to the grid
        Vector2 snapPosition = new(
            Mathf.Round(mousePosition.X / SnapDistance) * SnappingDistance,
            Mathf.Round(mousePosition.Y / SnapDistance) * SnappingDistance
        );
        _searchPanelInstance.PositionOffset = snapPosition;
    }

    private void OnAddBuilding(Recipe recipe)
    {
        int[] portCount = { recipe.Inputs.Length, recipe.Outputs.Length };
        switch (portCount[0], portCount[1])
        {
            case (1, 1):
                InstantiateBuilding(_oneInputOneOutput, recipe);
                break;
            case (1, 2):
                InstantiateBuilding(_oneInputTwoOutput, recipe);
                break;
            case (2, 1):
                InstantiateBuilding(_twoInputOneOutput, recipe);
                break;
            case (3, 1):
                InstantiateBuilding(_threeInputOneOutput, recipe);
                break;
            case (4, 1):
                InstantiateBuilding(_fourInputOneOutput, recipe);
                break;
            case (0, 1):
                InstantiateBuilding(_oneOutput, recipe);
                break;
            case (2, 2):
                InstantiateBuilding(_twoInputTwoOutput, recipe);
                break;
            case (4, 2):
                InstantiateBuilding(_fourInputTwoOutput, recipe);
                break;
            case (3, 2):
                InstantiateBuilding(_threeInputTwoOutput, recipe);
                break;
        }
    }

    private void InstantiateBuilding(PackedScene building, Recipe recipe)
    {
        if (building == null) return;
        Building buildingInstance = (Building)building.Instantiate();
        AddChild(buildingInstance);
        buildingInstance.SetupBuilding(recipe);
        buildingInstance.PositionOffset = _searchPanelInstance.PositionOffset;
        buildingInstance.BuildingValuesUpdated += OnBuildingValuesUpdated;
        _searchPanelInstance.Selected = false;
    }

    private void OnBuildingValuesUpdated(StringName buildingName, int slot, float value)
    {
        throw new NotImplementedException();
    }

    private void OnPanelDisabled()
    {
        RemoveChild(_searchPanelInstance);
    }

    private static Recipe[] SetItemIds(Recipe[] recipes)
    {
        List<Item> itemList = new();
        int id = 0;
        foreach (Recipe recipe in recipes)
        {
            foreach (ItemAmount input in recipe.Inputs)
            {
                if (itemList.Contains(input.Item)) continue;
                itemList.Add(input.Item);
                input.Item.Id = id;
                id++;
            }

            foreach (ItemAmount output in recipe.Outputs)
            {
                if (itemList.Contains(output.Item)) continue;
                itemList.Add(output.Item);
                output.Item.Id = id;
                id++;
            }
        }

        return recipes;
    }
}