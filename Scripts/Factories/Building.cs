using Godot;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using static BuildingSlot;

public partial class Building : GraphNode
{
    [Signal]
    public delegate void BuildingValuesUpdatedEventHandler(StringName buildingName, int slot, float value);

    public HashSet<Connection> Connections = new();
    private Recipe _recipe;
    private Label _buildingName;
    private BuildingSlot _buildingAmountText;
    [Export] private VBoxContainer[] _inputContainers;
    [Export] private VBoxContainer[] _outputContainers;
    private List<List<Node>> _inputNodes = new();
    private List<List<Node>> _outputNodes = new();
    private List<BuildingSlot> _inputAmounts = new();
    private List<BuildingSlot> _outputAmounts = new();


    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        SetCloseButton();
        _buildingName = GetNode<Label>("Buildings/BuildingName");
        _buildingAmountText = GetNodeOrNull<BuildingSlot>("Buildings/LineEdit");


        foreach (VBoxContainer container in _inputContainers)
        {
            List<Node> childrenList = container.GetChildren().ToList();
            _inputNodes.Add(childrenList);
        }

        foreach (var container in _outputContainers)
        {
            List<Node> childrenList = container.GetChildren().ToList();
            _outputNodes.Add(container.GetChildren().ToList());
        }
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    public void SetupBuilding(Recipe recipe)
    {
        _recipe = recipe;
        Title = recipe.Name;
        _buildingName.Text = recipe.GetBuildingType() + " (" + recipe.GetCyclesPerMin() + " sec)";

        SetItemDisplay();
        SetPortType();
        OnSlotValueUpdated(SlotType.Building, 1);
    }

    private void SetItemDisplay()
    {
        for (int i = 0; i < _inputNodes.Count; i++)
        {
            Label label = (Label)_inputNodes[i][0];
            label.Text = _recipe.GetInputItem(i).Name;
            TextureRect texture = (TextureRect)_inputNodes[i][1];
            texture.Texture = _recipe.GetInputItem(i).Icon;
            _inputAmounts.Add(_inputNodes[i][2].GetNode<BuildingSlot>("LineEdit"));
        }

        for (int i = 0; i < _outputNodes.Count; i++)
        {
            Label label = (Label)_outputNodes[i][0];
            label.Text = _recipe.GetOutputItem(i).Name;
            TextureRect texture = (TextureRect)_outputNodes[i][1];
            texture.Texture = _recipe.GetOutputItem(i).Icon;
            _outputAmounts.Add(_outputNodes[i][2].GetNode<BuildingSlot>("LineEdit"));
        }
    }

    private void SetPortType()
    {
        int inputPortCount = GetInputPortCount();
        int outputPortCount = GetOutputPortCount();

        for (int i = 0; i < inputPortCount; i++)
        {
            SetSlotColorLeft(i + 1, new Color(1, 1, 1));
            SetSlotTypeLeft(i + 1, _recipe.GetInputItem(i).Id);
        }

        for (int i = 0; i < outputPortCount; i++)
        {
            SetSlotColorRight(i + 1, new Color(1, 1, 1));
            SetSlotTypeRight(i + 1, _recipe.GetOutputItem(i).Id);
        }
    }

    private void OnSlotValueUpdated(SlotType slot, float value)
    {
        int slotIndex = ParseSlotType(slot);
        float buildingAmount = 0;
        float itemsPerMinPerBuilding = 0;
        float cyclesPerMin = _recipe.GetCyclesPerMin();

        if (IsInput(slot))
        {
            itemsPerMinPerBuilding = _recipe.Inputs[slotIndex].Amount * cyclesPerMin;
        }
        else if (IsOutput(slot))
        {
            itemsPerMinPerBuilding = _recipe.Outputs[slotIndex].Amount * cyclesPerMin;
        }
        else if (IsOnlyOutput(slot) || IsOnlyInput(slot))
        {
            EmitSignal(SignalName.BuildingValuesUpdated, Name, (int)slot, value);
            return;
        }

        //If the slot is a building slot, skip the building amount calculation
        if (IsBuilding(slot))
        {
            UpdateBuildingAmountText(value);
            buildingAmount = value;
        }
        else
        {
            buildingAmount = value / itemsPerMinPerBuilding;
            _buildingAmountText.Value = Math.Round(buildingAmount, 4).ToString(CultureInfo.InvariantCulture);
        }

        for (int i = 0; i < _inputAmounts.Count; i++)
        {
            float itemsPerMin = buildingAmount * _recipe.Inputs[i].Amount * cyclesPerMin;
            _inputAmounts[i].Value = Math.Round(itemsPerMin, 4).ToString(CultureInfo.InvariantCulture);
        }

        for (int i = 0; i < _outputAmounts.Count; i++)
        {
            float itemsPerMin = buildingAmount * _recipe.Outputs[i].Amount * cyclesPerMin;
            _outputAmounts[i].Value = Math.Round(itemsPerMin, 4).ToString(CultureInfo.InvariantCulture);
        }
    }

    private void UpdateSlotValues(SlotType slot, float value)
    {
    }

    private void UpdateBuildingAmountText(float value)
    {
        if (_buildingAmountText != null)
        {
            _buildingAmountText.Text = Math.Round(value, 4).ToString(CultureInfo.InvariantCulture);
        }
    }

    private void SetCloseButton()
    {
        HBoxContainer titleBar = GetTitlebarHBox();
        Button closeButton = new Button();
        closeButton.Text = " X ";
        closeButton.Pressed += QueueFree;
        titleBar.AddChild(closeButton);
    }

    public void DeselectBuilding()
    {
        Selected = false;
    }
}