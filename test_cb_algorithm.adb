-- test_cb_algorithm.adb
-- Test program for the CB Algorithm (CI Tests + K2)
-- This demonstrates the Bayesian Network structure learning

with Bayesian_Network_Learning; use Bayesian_Network_Learning;
with Ada.Text_IO; use Ada.Text_IO;

procedure Test_CB_Algorithm is
   -- Test database with 4 nodes and 10 samples
   -- Nodes: 1, 2, 3, 4
   -- Simple pattern: Node 1 causes Node 2, Node 3 causes Node 4
   Test_Data : Database(1 .. 10, 1 .. 4) :=
     (
      -- Sample 1: 1=F, 2=F, 3=F, 4=F
      (1 => (1 => False, 2 => False, 3 => False, 4 => False)),
      -- Sample 2: 1=T, 2=T, 3=F, 4=F
      (2 => (1 => True,  2 => True,  3 => False, 4 => False)),
      -- Sample 3: 1=F, 2=F, 3=T, 4=T
      (3 => (1 => False, 2 => False, 3 => True,  4 => True)),
      -- Sample 4: 1=T, 2=T, 3=T, 4=T
      (4 => (1 => True,  2 => True,  3 => True,  4 => True)),
      -- Sample 5: 1=F, 2=F, 3=F, 4=F
      (5 => (1 => False, 2 => False, 3 => False, 4 => False)),
      -- Sample 6: 1=T, 2=T, 3=F, 4=F
      (6 => (1 => True,  2 => True,  3 => False, 4 => False)),
      -- Sample 7: 1=F, 2=F, 3=T, 4=T
      (7 => (1 => False, 2 => False, 3 => True,  4 => True)),
      -- Sample 8: 1=T, 2=T, 3=T, 4=T
      (8 => (1 => True,  2 => True,  3 => True,  4 => True)),
      -- Sample 9: 1=F, 2=F, 3=F, 4=F
      (9 => (1 => False, 2 => False, 3 => False, 4 => False)),
      -- Sample 10: 1=T, 2=T, 3=T, 4=T
      (10 => (1 => True,  2 => True,  3 => True,  4 => True))
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
   for I in Node_Id range 1 .. Learned_Graph.Node_Count loop
      for J in Node_Id range 1 .. Learned_Graph.Node_Count loop
         Put(" " & Boolean'Image(Learned_Graph.Adjacent(I, J)));
      end loop;
      New_Line;
   end loop;
   New_Line;

   -- Print directed edges matrix
   Put_Line("Directed Edges Matrix (from Phase II):");
   for I in Node_Id range 1 .. Learned_Graph.Node_Count loop
      for J in Node_Id range 1 .. Learned_Graph.Node_Count loop
         Put(" " & Boolean'Image(Learned_Graph.Directed_Edges(I, J)));
      end loop;
      New_Line;
   end loop;
   New_Line;

   -- Print parent relationships
   Put_Line("Parent Relationships:");
   for I in Node_Id range 1 .. Learned_Graph.Node_Count loop
      Put("Node " & Node_Id'Image(I) & " parents: ");
      for J in Parent_Index range 1 .. Learned_Graph.Parent_Counts(I) loop
         Put(Node_Id'Image(Learned_Graph.Parents(I, J)) & " ");
      end loop;
      New_Line;
   end loop;
   New_Line;

   -- Test topological sort
   Put_Line("Testing Topological Sort...");
   Topological_Sort(Learned_Graph, Ordering);
   Put("Topological Order: ");
   for I in Node_Id range 1 .. Learned_Graph.Node_Count loop
      Put(Node_Id'Image(Ordering(I)) & " ");
   end loop;
   New_Line;
   New_Line;

   -- Test cycle detection
   Put_Line("Testing Cycle Detection...");
   for I in Node_Id range 1 .. Learned_Graph.Node_Count loop
      for J in Node_Id range 1 .. Learned_Graph.Node_Count loop
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
