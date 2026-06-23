-- test_cb_algorithm.adb
-- Version 0.01
-- Test program for the CB Algorithm (CI Tests + K2)
-- This demonstrates the Bayesian Network structure learning

with Bayesian_Network_Learning; use Bayesian_Network_Learning;
with Ada.Text_IO; use Ada.Text_IO;

procedure Test_CB_Algorithm is
   -- Test database with 10 samples and 4 nodes
   -- Each row is a sample, each column is a node value
   Test_Data : Database(1 .. 10, 1 .. 4) :=
     (
      -- Sample 1: Node 1=F, Node 2=F, Node 3=F, Node 4=F
      (False, False, False, False),
      -- Sample 2: Node 1=T, Node 2=T, Node 3=F, Node 4=F
      (True,  True,  False, False),
      -- Sample 3: Node 1=F, Node 2=F, Node 3=T, Node 4=T
      (False, False, True,  True),
      -- Sample 4: Node 1=T, Node 2=T, Node 3=T, Node 4=T
      (True,  True,  True,  True),
      -- Sample 5: Node 1=F, Node 2=F, Node 3=F, Node 4=F
      (False, False, False, False),
      -- Sample 6: Node 1=T, Node 2=T, Node 3=F, Node 4=F
      (True,  True,  False, False),
      -- Sample 7: Node 1=F, Node 2=F, Node 3=T, Node 4=T
      (False, False, True,  True),
      -- Sample 8: Node 1=T, Node 2=T, Node 3=T, Node 4=T
      (True,  True,  True,  True),
      -- Sample 9: Node 1=F, Node 2=F, Node 3=F, Node 4=F
      (False, False, False, False),
      -- Sample 10: Node 1=T, Node 2=T, Node 3=T, Node 4=T
      (True,  True,  True,  True)
     );

   Learned_Graph : Graph;
   Ordering : Node_Ordering(1 .. 4);

begin
   Put_Line("=== CB Algorithm Test ===");
   Put_Line("Testing Bayesian Network Structure Learning");
   Put_Line("Input: 10 samples, 4 nodes");
   New_Line;

   -- Run the CB algorithm
   Put_Line("Running CB Algorithm...");
   CB_Algorithm(Test_Data, Learned_Graph);
   Put_Line("CB Algorithm completed!");
   New_Line;

   -- Display results
   Put_Line("=== Results ===");
   Put_Line("Node Count: " & Node_Count_Type'Image(Learned_Graph.Node_Count));
   Put_Line("Edge Count: " & Edge_Count_Type'Image(Learned_Graph.Edge_Count));
   New_Line;

   -- Print adjacency matrix
   Put_Line("Adjacency Matrix (undirected edges from Phase I):");
   for I in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
      for J in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
         Put(" " & Boolean'Image(Learned_Graph.Adjacent(I, J)));
      end loop;
      New_Line;
   end loop;
   New_Line;

   -- Print directed edges matrix
   Put_Line("Directed Edges Matrix (from Phase II):");
   for I in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
      for J in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
         Put(" " & Boolean'Image(Learned_Graph.Directed_Edges(I, J)));
      end loop;
      New_Line;
   end loop;
   New_Line;

   -- Print parent relationships
   Put_Line("Parent Relationships:");
   for I in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
      Put("Node " & Node_Id'Image(I) & " parents: ");
      for J in Parent_Index range 1 .. Parent_Index(Learned_Graph.Parent_Counts(I)) loop
         Put(Node_Id'Image(Learned_Graph.Parents(I, J)) & " ");
      end loop;
      New_Line;
   end loop;
   New_Line;

   -- Test topological sort
   Put_Line("Testing Topological Sort...");
   Topological_Sort(Learned_Graph, Ordering);
   Put("Topological Order: ");
   for I in Positive range 1 .. Integer(Learned_Graph.Node_Count) loop
      Put(Node_Id'Image(Ordering(I)) & " ");
   end loop;
   New_Line;
   New_Line;

   -- Test cycle detection
   Put_Line("Testing Cycle Detection...");
   for I in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
      for J in Node_Id range 1 .. Node_Id(Learned_Graph.Node_Count) loop
         if I /= J then
            declare
               Has_Cycle : Boolean := Creates_Cycle(Learned_Graph, I, J);
            begin
               if Has_Cycle then
                  Put_Line("Adding edge " & Node_Id'Image(I) & " -> " & Node_Id'Image(J) & " would create a cycle");
               end if;
            end;
         end if;
      end loop;
   end loop;

   Put_Line("=== Test Complete ===");

end Test_CB_Algorithm;
