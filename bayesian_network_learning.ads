-- bayesian_network_learning.ads
-- Version 0.30
-- Full specification of CB Algorithm (CI Tests + K2) from Paper

pragma SPARK_Mode;

package Bayesian_Network_Learning is

   -- Constants for maximum sizes
   Max_Nodes : constant := 1000;
   Max_Edges : constant := 10000;
   Max_Parents : constant := 100;  -- Max parents per node
   Max_CI_Order : constant := 5;   -- Max order for CI tests
   Max_Factorial_Input : constant := 20;  -- Safe limit for Float factorial

   -- Basic types
   type Node_Id is range 1 .. Max_Nodes;
   type Edge_Id is range 1 .. Max_Edges;
   type Parent_Index is range 1 .. Max_Parents;
   type CI_Order is range 0 .. Max_CI_Order;

   -- Types for counts (start at 0)
   type Node_Count_Type is range 0 .. Max_Nodes;
   type Edge_Count_Type is range 0 .. Max_Edges;
   type Parent_Count_Type is range 0 .. Max_Parents;

   -- Discrete values for variables (simplified: binary for now)
   type Value is (False, True);
   type Value_Array is array (Positive range <>) of Value;

   -- Named array types for SPARK compatibility
   type Adjacency_Matrix_Type is array (Node_Id, Node_Id) of Boolean;
   type Directed_Edges_Matrix_Type is array (Node_Id, Node_Id) of Boolean;
   type Parent_Set_Type is array (Parent_Index) of Node_Id;
   type Parents_Array_Type is array (Node_Id) of Parent_Set_Type;
   type Parent_Counts_Array_Type is array (Node_Id) of Parent_Count_Type;
   type Node_Boolean_Array_Type is array (Node_Id) of Boolean;

   -- Database: array of cases, each case is a Value_Array
   type Database is array (Positive range <>, Positive range <>) of Value;

   -- Edge representation
   type Edge is record
      Source : Node_Id;
      Target : Node_Id;
   end record;

   -- Graph representation
   type Graph is record
      Node_Count : Node_Count_Type := 0;
      Edge_Count : Edge_Count_Type := 0;
      -- Adjacency matrix for undirected graph (Phase I)
      Adjacent : Adjacency_Matrix_Type := (others => (others => False));
      -- Directed edges (Phase II)
      Directed_Edges : Directed_Edges_Matrix_Type := (others => (others => False));
      -- Parents for each node (Phase II)
      Parents : Parents_Array_Type := (others => (others => Node_Id'First));
      Parent_Counts : Parent_Counts_Array_Type := (others => 0);
   end record;

   -- Node ordering type
   type Node_Ordering is array (Positive range <>) of Node_Id;

   -- CI test result
   function CI_Test (Data : Database; X, Y : Node_Id; Conditioning_Set : Parent_Set_Type;
                     Conditioning_Count : Parent_Count_Type) return Boolean
     with Pre => Data'Length > 0 and X <= Max_Nodes and Y <= Max_Nodes;

   -- K2 metric g(i, π_i) from Equation 2 in the paper
   function G_Metric (Data : Database; Node : Node_Id; Parent_Count : Parent_Count_Type) return Float
     with Pre => Data'Length > 0 and Node <= Max_Nodes and Parent_Count <= Max_Parents;

   -- Helper: Check if adding edge X->Y creates a cycle (SPARK-compatible)
   function Creates_Cycle (G : Graph; X, Y : Node_Id) return Boolean
     with Pre => X <= Max_Nodes and Y <= Max_Nodes;

   -- Factorial helper (for g-metric) with safe bounds
   function Factorial (N : Integer) return Float
     with Pre => N >= 0 and N <= Max_Factorial_Input,
          Post => Factorial'Result <= Float'Last;

   -- Phase I: Generate node ordering using CI tests
   procedure Phase_I (Data : Database; G : in out Graph; Ordering : out Node_Ordering)
     with Pre => Data'Length > 0,
          Post => Ordering'Length = G.Node_Count and G.Node_Count <= Max_Nodes;

   -- Phase II: K2 algorithm to construct DAG from ordering
   procedure Phase_II (Data : Database; Ordering : Node_Ordering; G : in out Graph)
     with Pre => Data'Length > 0 and Ordering'Length > 0 and Ordering'Length <= Max_Nodes,
          Post => G.Node_Count = Node_Count_Type(Ordering'Length) and G.Node_Count <= Max_Nodes;

   -- Topological sort for DAG
   procedure Topological_Sort (G : Graph; Ordering : out Node_Ordering);

   -- Main CB algorithm (combines Phase I and II iteratively)
   procedure CB_Algorithm (Data : Database; G : out Graph)
     with Pre => Data'Length > 0,
          Post => G.Node_Count <= Max_Nodes;

end Bayesian_Network_Learning;
