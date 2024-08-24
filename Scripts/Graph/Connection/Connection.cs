using System;
using System.Collections.Generic;
using Godot;

public class Connection
{
    public StringName FromNode { get; }
    public StringName ToNode { get; }
    public int FromPort { get; }
    public int ToPort { get; }

    public Connection(StringName fromNode, int fromPort, StringName toNode, int toPort)
    {
        FromNode = fromNode;
        FromPort = fromPort;
        ToNode = toNode;
        ToPort = toPort;
    }
    
    public override bool Equals(object obj)
    {
        if(obj== null || GetType() != obj.GetType())
        {
            return false;
        }
        Connection newConnection = (Connection)obj;
        return FromNode == newConnection.FromNode && ToNode == newConnection.ToNode && FromPort == newConnection.FromPort && ToPort == newConnection.ToPort;
    }
    
    public override int GetHashCode()
    {
        return HashCode.Combine(FromNode,ToNode,FromPort,ToPort);
    }
}