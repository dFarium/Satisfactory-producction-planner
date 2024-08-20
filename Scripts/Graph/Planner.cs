using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

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
    private PackedScene _searchPanel;
    private SearchPanel _searchPanelInstance;
    private List<Recipe> _recipes = new List<Recipe>();

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
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
        _searchPanel = ResourceLoader.Load<PackedScene>("res://Scenes/search_recipe.tscn");
        _recipes = RecipeLoader.LoadRecipes();
    }


    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    public override void _Input(InputEvent inputEvent)
    {
        if (!Input.IsActionJustPressed("right_click")) return;
        InstantiateSearchPanel();
    }

    private void InstantiateSearchPanel()
    {
        foreach (Node child in GetChildren())
        {
            if (child.HasMethod("deselect_building"))
            {
                child.Call("deselect_building");
            }
        }

        if (_searchPanelInstance == null)
        {
            _searchPanelInstance =
                (SearchPanel)ResourceLoader.Load<PackedScene>("res://Scenes/search_recipe.tscn").Instantiate();
            _searchPanelInstance.RecipeList = _recipes;
            _searchPanelInstance.PanelDisabled += OnPanelDisabled;
            _searchPanelInstance.AddBuilding += OnAddBuilding;
            AddChild(_searchPanelInstance);
        }
        else if (!_searchPanelInstance.Enabled)
        {
            AddChild(_searchPanelInstance);
            _searchPanelInstance.EnablePanel();
        }
        
        Vector2 mousePosition = (GetGlobalMousePosition() + ScrollOffset) / Zoom;
        //Snap the panel to the grid
        Vector2 snapPosition = new(
            Mathf.Round(mousePosition.X/ SnapDistance) * SnappingDistance,
            Mathf.Round(mousePosition.Y/ SnapDistance) * SnappingDistance
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

    private void OnBuildingValuesUpdated(StringName buildingname, int slot, float value)
    {
        throw new NotImplementedException();
    }

    private void OnPanelDisabled()
    {
        RemoveChild(_searchPanelInstance);
    }
}