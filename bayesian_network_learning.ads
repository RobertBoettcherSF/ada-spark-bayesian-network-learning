-- bayesian_network_learning.ads
-- Version 0.10
-- Specification of Bayesian Network Structure Learning (CB Algorithm from Paper)

pragma SPARK_Mode;

package Bayesian_Network_Learning is

   -- Basic types for nodes and edges
   type Node_Id is range 1 .. 1000;
   type Edge_Id is range 1 .. 10000;

   -- Types for counts (start at 0)
   type Node_Count_Type is range 0 .. Node_Id'Last;
   type Edge_Count_Type is range 0 .. Edge_Id'Last;

   -- Data type for discrete variable values (simplified: 0 = False, 1 = True)
   type Value is (False, True);
   type Value_Array is array (Positive range <>) of Value;

   -- Graph components
   type Node is record
      Id : Node_Id;
   end record;

   type Edge is record
      Source : Node_Id;
      Target : Node_Id;
      Weight : Float;
   end record;

   -- Parent set for a node (static array for SPARK compatibility)
   type Parent_Set is array (Positive range <>) of Node_Id;

   -- 2D array type for parents (Node_Id x Parent index)
   type Parent_Array is array (Node_Id, Positive range 1 .. Node_Id'Last) of Node_Id;

   -- Graph type
   type Graph is record
      Node_Count : Node_Count_Type := 0;
      Edge_Count : Edge_Count_Type := 0;
      Parents : Parent_Array;
   end record
     with Relaxed_Initialization;

   -- Database type: array of cases, each case is a Value_Array
   type Database is array (Positive range <>, Positive range <>) of Value;

   -- Node ordering type (static array for SPARK compatibility)
   type Node_Ordering is array (Positive range <>) of Node_Id;

   -- CI test result
   function CI_Test (Data : Database; X, Y : Node_Id; Conditioning_Set : Parent_Set) return Boolean
     with Pre => Data'Length > 0 and X <= Node_Id'Last and Y <= Node_Id'Last;

   -- K2 metric g(i, π_i) from Equation 2 in the paper
   function G_Metric (Data : Database; Node : Node_Id; Parents : Parent_Set) return Float
     with Pre => Data'Length > 0 and Node <= Node_Id'Last;

   -- Phase I: Generate node ordering using CI tests (simplified for SPARK)
   procedure Generate_Ordering (Data : Database; Ordering : out Node_Ordering)
     with Pre => Data'Length > 0,
          Post => Ordering'Length <= Node_Id'Last;

   -- Phase II: K2 algorithm to construct DAG from ordering
   procedure K2_Algorithm (Data : Database; Ordering : Node_Ordering; Result : out Graph)
     with Pre => Data'Length > 0 and Ordering'Length > 0,
          Post => Result.Node_Count <= Node_Count_Type(Node_Id'Last);

   -- Topological sort for DAG
   procedure Topological_Sort (G : Graph; Ordering : out Node_Ordering)
     with Pre => True,
          Post => Ordering'Length = G.Node_Count;

end Bayesian_Network_Learning;
