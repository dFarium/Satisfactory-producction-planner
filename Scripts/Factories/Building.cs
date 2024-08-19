using Godot;
using System;
using System.Collections.Generic;

public partial class Building : GraphNode
{
    [Signal]
    public delegate void SlotValueUpdatedEventHandler(StringName slotName, int slot, float value);

    private Recipe _recipe;
    private Label _buildingName;
    private LineEdit _buildingAmountText;
    [Export] private VBoxContainer[] _inputSlots;
    [Export] private VBoxContainer[] _outputSlots;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    public void SetupBuilding(Recipe recipe)
    {
        _recipe = recipe;
        Title = recipe.Name;
    }
}