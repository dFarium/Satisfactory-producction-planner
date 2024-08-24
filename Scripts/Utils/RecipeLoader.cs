using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class RecipeLoader
{
    
    public static List<Recipe> LoadRecipes()
    {
        JsonToResource jsonToResource = new JsonToResource();
        List<JsonToResource.JsonRecipe> jsonRecipes = jsonToResource.LoadRecipesFromJson("D:/!Descargas/recipes.json").ToList();
        
        int id = 0;
        List<Recipe> recipeList = new List<Recipe>();
        DirAccess dir = DirAccess.Open("res://Recipes/");

        // Verifica si el directorio "Recipes" se pudo abrir
        if (dir == null)
            return recipeList;

        dir.ListDirBegin();
        string subDirName = dir.GetNext();

        // Recorre cada subcarpeta dentro de "Recipes"
        while (subDirName != "")
        {
            // Si no es un directorio, pasa al siguiente elemento
            if (!dir.CurrentIsDir())
            {
                subDirName = dir.GetNext();
                continue;
            }

            string subDirPath = "res://Recipes/" + subDirName;


            DirAccess tierDir = DirAccess.Open(subDirPath);
            if (tierDir == null)
            {
                subDirName = dir.GetNext();
                continue;
            }

            tierDir.ListDirBegin();
            string outputDirName = tierDir.GetNext();

            // Loop through each output subfolder within the current tier
            while (outputDirName != "")
            {
                if (!tierDir.CurrentIsDir())
                {
                    outputDirName = tierDir.GetNext();
                    continue;
                }

                string outputDirPath = subDirPath + "/" + outputDirName;
                DirAccess outputDir = DirAccess.Open(outputDirPath);
                if (outputDir == null)
                {
                    outputDirName = tierDir.GetNext();
                    continue;
                }

                outputDir.ListDirBegin();
                string recipeFile = outputDir.GetNext();

                List<Recipe> recipeGroup = new List<Recipe>();
                // Loop through each recipe file within the current output type
                while (recipeFile != "")
                {
                    if (outputDir.CurrentIsDir())
                    {
                        recipeFile = outputDir.GetNext();
                        continue;
                    }

                    // Load the recipe resource and add it to the recipe list
                    Recipe recipe = (Recipe)ResourceLoader.Load(outputDirPath + "/" + recipeFile);
                    //Set recipe enum
                    recipe.Building= JsonToResource.StringToEnum(jsonRecipes.Find(i => i.Name == recipe.Name).Building);
                    ResourceSaver.Save(recipe, outputDirPath + "/" + recipeFile);
                    recipeGroup.Add(recipe);
                    id++;

                    recipeFile = outputDir.GetNext();
                }

                recipeGroup = SortRecipes(recipeGroup);
                recipeList.AddRange(recipeGroup);
                outputDir.ListDirEnd();

                outputDirName = tierDir.GetNext();
            }

            tierDir.ListDirEnd();


            subDirName = dir.GetNext();
        }

        dir.ListDirEnd();

        // Set Id to each recipe
        return SetItemIds(recipeList);
    }

    private static List<Recipe> SetItemIds(List<Recipe> recipes)
    {
        int id = 0;
        foreach (Recipe recipe in recipes)
        {
            recipe.Id = id;
            id++;
        }

        return recipes;
    }

    public static List<Recipe> SortRecipes(List<Recipe> recipes)
    {
        return recipes.OrderBy(r => r.IsAlternative).ToList();
    }

    public void MakeRecipeListResource()
    {
        
        
        int id = 0;
        List<Recipe> recipes = LoadRecipes();
        List<Recipe> newRecipes = new List<Recipe>(); 
        foreach (var recipe in recipes)
        {
            newRecipes.Add(new Recipe(id, recipe.Name, recipe.Inputs, recipe.Outputs, recipe.ProcessingTime, recipe.IsAlternative, recipe.Building));
            id++;
        }
        RecipeList recipeList = new (newRecipes.ToArray());
        ResourceSaver.Save(recipeList,"res://Recipes/recipe_list.tres");
        GD.Print("Saved recipe list");
    }
    
    public static void SetIdQuick()
    {
        int id = 0;
        RecipeList recipeList = (RecipeList)ResourceLoader.Load("res://Recipes/recipe_list.tres");
        foreach (var recipe in recipeList.Recipes)
        {
            recipe.Id = id;
            id++;
        }
        ResourceSaver.Save(recipeList,"res://Recipes/recipe_list.tres");
    }
    
}