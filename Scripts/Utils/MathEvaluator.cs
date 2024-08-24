using System.Globalization;
using NCalc;
using Godot;
using Expression = NCalc.Expression;

public partial class MathEvaluator
{
    public static string EvaluateValidInput(string expression)
    {
        //TODO : check expression only if is an arithmetic expression
        CultureInfo.DefaultThreadCurrentCulture = CultureInfo.InvariantCulture;
        expression = expression.Replace(',', '.');
        string inputValidate = "(" + expression + ") >= 0";
        Expression e = new Expression(inputValidate);

        try
        {
            object result = e.Evaluate();
            if (result is true)
            {
                e = new Expression(expression);
                result = e.Evaluate();
                return result?.ToString();
            }

            return null;
        }
        catch
        {
            return null;
        }
    }
}