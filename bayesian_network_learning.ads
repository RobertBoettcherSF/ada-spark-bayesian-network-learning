-- bayesian_network_learning.ads
-- Version 0.05
-- Specification of Bayesian Network Structure Learning package

pragma SPARK_Mode;

package Bayesian_Network_Learning is

   -- Define basic types for nodes, edges, and graph
   type Node_Id is range 1 .. 1000;  -- Node IDs start at 1
   type Edge_Id is range 1 .. 10000; -- Edge IDs start at 1

   -- Separate types for counts (start at 0)
   type Node_Count_Type is range 0 .. Node_Id'Last;
   type Edge_Count_Type is range 0 .. Edge_Id'Last;

   type Node is record
      Id : Node_Id;
   end record;

   type Edge is record
      Source : Node_Id;
      Target : Node_Id;
      Weight : Float;
   end record;

   -- Define named array types for SPARK compatibility (using Positive for bounds)
   type Node_Array is array (Positive range <>) of Node_Id;
   type Edge_Array is array (Positive range <>) of Edge;

   type Graph is record
      Nodes : Node_Array(1 .. Integer(Node_Id'Last));
      Edges : Edge_Array(1 .. Integer(Edge_Id'Last));
      Node_Count : Node_Count_Type := 0;
      Edge_Count : Edge_Count_Type := 0;
   end record;

   -- Placeholder for data type
   type Data_Array is array (Positive range <>) of Float;

   -- Subprogram to perform Conditional Independence (CI) test
   function CI_Test (Data : Data_Array; X, Y, Z : Node_Id) return Boolean
     with Pre => Data'Length >= 3 and X <= Node_Id'Last and Y <= Node_Id'Last and Z <= Node_Id'Last;

   -- Subprogram to apply K2 algorithm to construct DAG from node ordering
   procedure K2_Algorithm (Data : Data_Array; Ordering : Node_Array; Result : out Graph)
     with Pre => Data'Length > 0 and Ordering'Length > 0,
          Post => Result.Node_Count <= Node_Count_Type(Node_Id'Last) and
                 Result.Edge_Count <= Edge_Count_Type(Edge_Id'Last);

end Bayesian_Network_Learning;
