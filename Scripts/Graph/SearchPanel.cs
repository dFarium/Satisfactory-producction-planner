using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class SearchPanel : GraphNode
{
    [Signal]
    public delegate void PanelDisabledEventHandler();

    [Signal]
    public delegate void AddBuildingEventHandler(Recipe recipe);

    public List<Recipe> RecipeList { get; set; }
    public bool Enabled { get; set; }

    private LineEdit _searchBar;
    private List<RecipeButton> _recipeButtons = new List<RecipeButton>();
    private VBoxContainer _recipeListContainer;
    private ScrollContainer _scrollContainer;
    private PackedScene _recipeButton;


    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        LoadComponents();
        _searchBar.TextChanged += OnSearchBarTextChanged;
        NodeDeselected += OnNodeDeselected;
        InitRecipeButtons();
    }

    private void LoadComponents()
    {
        _recipeListContainer = GetNode<VBoxContainer>("ScrollContainer/VBoxContainer");
        _scrollContainer = GetNode<ScrollContainer>("ScrollContainer");
        _searchBar = GetNode<LineEdit>("LineEdit");
        _recipeButton = ResourceLoader.Load<PackedScene>("res://Scenes/button_option.tscn");
    }

    private void OnSearchBarTextChanged(string newText)
    {
        HideButtons();
        if (newText.Length > 0)
        {
            ShowRecipes(SearchRecipes(newText));
        }
        else
        {
            ShowRecipes(RecipeList);
        }
    }

    private void HideButtons()
    {
        foreach (Node node in _recipeListContainer.GetChildren())
        {
            Control button = (Control)node;
            button.Visible = false;
        }
    }

    private void OnNodeDeselected()
    {
        DisablePanel();
    }

    private List<Recipe> SearchRecipes(string query)
    {
        var recipes = new List<Recipe>();
        foreach (Recipe recipe in RecipeList)
        {
            foreach (ItemAmount output in recipe.Outputs)
            {
                if (output.Item.Name.Contains(query, StringComparison.OrdinalIgnoreCase))
                {
                    recipes.Add(recipe);
                    break;
                }
            }
        }

        return recipes;
    }

    private void ShowRecipes(List<Recipe> recipes)
    {
        foreach (RecipeButton button in _recipeButtons)
        {
            if (recipes.Contains(button.Recipe))
            {
                button.Visible = true;
            }
        }
    }

    private void InitRecipeButtons()
    {
        foreach (Recipe recipe in RecipeList)
        {
            RecipeButton recipeButton = (RecipeButton)_recipeButton.Instantiate();
            _recipeListContainer.AddChild(recipeButton);
            _recipeButtons.Add(recipeButton);
            recipeButton.SetRecipe(recipe);
            recipeButton.RecipeButtonPressed += OnRecipeButtonPressed;
        }
    }

    private void OnRecipeButtonPressed(Recipe recipe)
    {
        EmitSignal(SignalName.AddBuilding, recipe);
    }

    public void EnablePanel()
    {
        Enabled = true;
        Visible = true;
        Selected = true;
        SetProcess(true);
        SetPhysicsProcess(true);
        SetProcessInput(true);
        SetBlockSignals(false);
        ResetPanel();
    }

    public void DisablePanel()
    {
        Enabled = false;
        Visible = false;
        Selected = false;
        EmitSignal(SignalName.PanelDisabled);
        SetProcess(false);
        SetPhysicsProcess(false);
        SetProcessInput(false);
        SetBlockSignals(true);
    }

    private void ResetPanel()
    {
        _searchBar.Text = "";
        _scrollContainer.ScrollVertical = 0;
        ShowRecipes(RecipeList);
    }
}