using Godot;
using System;

public partial class RecipeList : Resource
{
    [Export]public Recipe[] Recipes { get; set; }

    public RecipeList() : this(null)
    {
    }

    public RecipeList(Recipe[] recipes)
    {
        Recipes = recipes;
    }
}