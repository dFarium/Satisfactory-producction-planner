using Godot;

[GlobalClass]
public partial class ItemAmount : Resource
{
    [Export] public Item Item { get; set; }
    [Export] public float Amount { get; set; }

    public ItemAmount() : this(null, 0)
    {
    }

    public ItemAmount(Item item, float amount)
    {
        Item = item;
        Amount = amount;
    }
}