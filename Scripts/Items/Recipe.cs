using Godot;

[GlobalClass]
public partial class Recipe : Resource
{
    [Export] public string Name { get; set; }
    [Export] public ItemAmount[] Inputs { get; set; }
    [Export] public ItemAmount[] Outputs { get; set; }
    [Export] public float ProcessingTime { get; set; }
    [Export] public bool IsAlternative { get; set; }
    
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
}