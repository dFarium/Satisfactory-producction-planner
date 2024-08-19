using Godot;
using System;
using System.Collections.Generic;

public partial class RecipeButton : Button
{
    [Signal]
    public delegate void RecipeButtonPressedEventHandler(Recipe recipe);

    // Called when the node enters the scene tree for the first time.
    private Label _recipeName;
    private List<TextureRect> _recipeIcons;
    private TextureRect _optionIcon1;
    private TextureRect _optionIcon2;
    private TextureRect _optionIcon3;
    private TextureRect _optionIcon4;
    private TextureRect _optionIcon5;
    private TextureRect _optionIcon6;
    private TextureRect _optionIcon7;
    private Texture2D _arrowIcon;
    private LabelSettings _regularRecipeLabelSettings = new LabelSettings();
    private LabelSettings _alternativeRecipeLabelSettings = new LabelSettings();

    public Recipe Recipe { get; set; }

    public override void _Ready()
    {
        Pressed += OnPressed;
        _regularRecipeLabelSettings.FontColor = new Color(1f, 1f, 1f);
        _alternativeRecipeLabelSettings.FontColor = new Color(0.98f, 0.584f, 0.286f);
        _recipeName = GetNode<Label>("HBoxContainer/Label");
        _optionIcon1 = GetNode<TextureRect>("HBoxContainer/option_icon1");
        _optionIcon2 = GetNode<TextureRect>("HBoxContainer/option_icon2");
        _optionIcon3 = GetNode<TextureRect>("HBoxContainer/option_icon3");
        _optionIcon4 = GetNode<TextureRect>("HBoxContainer/option_icon4");
        _optionIcon5 = GetNode<TextureRect>("HBoxContainer/option_icon5");
        _optionIcon6 = GetNode<TextureRect>("HBoxContainer/option_icon6");
        _optionIcon7 = GetNode<TextureRect>("HBoxContainer/option_icon7");
        _arrowIcon = (Texture2D)ResourceLoader.Load("res://ItemIcons/arrowRight.png");
        _recipeIcons = new List<TextureRect>
        {
            _optionIcon1,
            _optionIcon2,
            _optionIcon3,
            _optionIcon4,
            _optionIcon5,
            _optionIcon6,
            _optionIcon7
        };
    }

    private void OnPressed()
    {
        EmitSignal(SignalName.RecipeButtonPressed, Recipe);
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    public void SetRecipe(Recipe recipe)
    {
        Recipe = recipe;
        int i = 0;
        _recipeName.Text = Recipe.Name;
        // Clear all icons
        foreach (TextureRect icon in _recipeIcons)
        {
            icon.Texture = null;
        }

        // Set input icons
        foreach (ItemAmount input in Recipe.Inputs)
        {
            _recipeIcons[i].Texture = input.Item.Icon;
            i++;
        }

        // Set arrow icon
        _recipeIcons[i].Texture = _arrowIcon;
        i++;
        // Set output icons
        foreach (ItemAmount output in Recipe.Outputs)
        {
            _recipeIcons[i].Texture = output.Item.Icon;
            i++;
        }

        // Set label color
        if (Recipe.IsAlternative)
        {
            _recipeName.LabelSettings = _alternativeRecipeLabelSettings;
        }
        else
        {
            _recipeName.LabelSettings = _regularRecipeLabelSettings;
        }
    }
}