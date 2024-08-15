using Godot;

[GlobalClass]
public partial class Item : Resource
{
    public int Id { get; set; }
    [Export] public string Name { get; set; }
    [Export] public Texture2D Icon { get; set; }

    public Item() : this(0, "", null)
    {
    }

    public Item(int id, string name, Texture2D icon)
    {
        Id = id;
        Name = name;
        Icon = icon;
    }
}