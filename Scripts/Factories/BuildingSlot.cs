using Godot;
using System;

public partial class BuildingSlot : LineEdit
{
    [Signal]
    public delegate void SlotValueUpdatedEventHandler(SlotType slot, float value);

    public enum SlotType
    {
        //Undef
        Undefined,

        //Building amount
        Building,
        OnlyInput,
        OnlyOutput,

        //Inputs 
        Input1,
        Input2,
        Input3,
        Input4,
        Input5,
        Input6,

        //Outputs
        Output1,
        Output2,
        Output3,
        Output4,
        Output5,
        Output6
    }

    [Export] private SlotType _slotType = SlotType.Undefined;
    private string _lastValidValue = "0";
    public string Value
    {
        get => Text;
        set
        {
            Text = value;
            _lastValidValue = value;
        }
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        TextSubmitted += OnTextSubmitted;
        FocusExited += OnFocusExited;
    }

    private void OnFocusExited()
    {
        CheckInput();
        EmitSignal(SignalName.SlotValueUpdated, (int)_slotType, Text.ToFloat());
    }

    private void OnTextSubmitted(string newText)
    {
        CheckInput();
        EmitSignal(SignalName.SlotValueUpdated, (int)_slotType, Text.ToFloat());
    }

    private void CheckInput()
    {
        string evaluatedInput = MathEvaluator.EvaluateValidInput(Text);
        if (evaluatedInput == null)
        {
            Value = _lastValidValue;
        }
        else
        {
            Value = evaluatedInput;
        }
    }

    public static bool IsInput(SlotType slot)
    {
        return slot >= SlotType.Input1 && slot <= SlotType.Input6;
    }

    public static bool IsOutput(SlotType slot)
    {
        return slot >= SlotType.Output1 && slot <= SlotType.Output6;
    }

    public static bool IsOnlyOutput(SlotType slot)
    {
        return slot == SlotType.OnlyOutput;
    }

    public static bool IsOnlyInput(SlotType slot)
    {
        return slot == SlotType.OnlyInput;
    }

    public static bool IsBuilding(SlotType slot)
    {
        return slot == SlotType.Building;
    }

    public static int ParseSlotType(SlotType slotType)
    {
        // Parse inputs
        if (slotType >= SlotType.Input1 && slotType <= SlotType.Input6)
        {
            return (int)slotType - (int)SlotType.Input1;
        }

        // Parse outputs
        if (slotType >= SlotType.Output1 && slotType <= SlotType.Output6)
        {
            return (int)slotType - (int)SlotType.Output1;
        }

        // Return -1 for undefined or other types
        return -1;
    }
}