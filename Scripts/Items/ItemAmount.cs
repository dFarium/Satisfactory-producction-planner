using Godot;

[GlobalClass]
public partial class ItemAmount : Resource
{
    [Export] public Item Item { get; set; }
    [Export] public int Amount { get; set; }

    public ItemAmount() : this(null, 0)
    {
    }

    public ItemAmount(Item item, int amount)
    {
        Item = item;
        Amount = amount;
    }
}