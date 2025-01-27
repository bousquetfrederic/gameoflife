with Ada.Text_IO; use Ada.Text_IO;

package body Generic_Board is

   --  For each cell of the board, use the 8 pointers to
   --  count the number of alive neighbours.
   procedure Count_Neighbours (Board : T_Board) is
   begin
      for Col in T_Cols range T_Cols'First + 1 .. T_Cols'Last - 1 loop
         for Row in T_Rows range T_Rows'First + 1 .. T_Rows'Last - 1 loop
            declare
               Cell : T_Cell renames Board.Grid (Row, Col);
            begin
               Cell.Total_Neighbour_Count := 0;
               for N in T_Neighbours loop
                  Cell.Total_Neighbour_Count :=
                    Cell.Total_Neighbour_Count
                    + Cell.Neighbour_Count (N).all;
               end loop;
            end;
         end loop;
      end loop;
   end Count_Neighbours;

   --  Create for each cell the pointers to the 8 neighbours.
   --  Cells on the borders have walls as neighbours, we represent
   --  this by pointing to a special empty cell which remains
   --  dead all the time (like a wall).
   procedure Init_Links_Between_Cells (Board : T_Board) is
   begin
      --  set the link to the neighbours

      --  Fill the corner cells
      Board.Grid (T_Rows'First, T_Cols'First).Neighbour_Count :=
         (North_West => Board.Wall.Life_Count'Access,
          North => Board.Wall.Life_Count'Access,
          North_East => Board.Wall.Life_Count'Access,
          West => Board.Wall.Life_Count'Access,
          South_West => Board.Wall.Life_Count'Access,
          East =>
             Board.Grid (T_Rows'First, T_Cols'First + 1).Life_Count'Access,
          South_East =>
             Board.Grid
               (T_Rows'First + 1, T_Cols'First + 1).Life_Count'Access,
          South =>
             Board.Grid (T_Rows'First + 1, T_Cols'First).Life_Count'Access);

      Board.Grid (T_Rows'First, T_Cols'Last).Neighbour_Count :=
         (North_West => Board.Wall.Life_Count'Access,
          North => Board.Wall.Life_Count'Access,
          North_East => Board.Wall.Life_Count'Access,
          East => Board.Wall.Life_Count'Access,
          South_East => Board.Wall.Life_Count'Access,
          West =>
             Board.Grid (T_Rows'First, T_Cols'Last - 1).Life_Count'Access,
          South_West =>
             Board.Grid
                (T_Rows'First + 1, T_Cols'Last - 1).Life_Count'Access,
          South =>
             Board.Grid (T_Rows'First + 1, T_Cols'Last).Life_Count'Access);

      Board.Grid (T_Rows'Last, T_Cols'First).Neighbour_Count :=
         (North_West => Board.Wall.Life_Count'Access,
          West => Board.Wall.Life_Count'Access,
          South_West => Board.Wall.Life_Count'Access,
          South => Board.Wall.Life_Count'Access,
          South_East => Board.Wall.Life_Count'Access,
          East =>
             Board.Grid (T_Rows'Last, T_Cols'First + 1).Life_Count'Access,
          North_East =>
             Board.Grid
                (T_Rows'Last - 1, T_Cols'First + 1).Life_Count'Access,
          North =>
             Board.Grid (T_Rows'Last - 1, T_Cols'First).Life_Count'Access);

      Board.Grid (T_Rows'Last, T_Cols'Last).Neighbour_Count :=
         (North_East => Board.Wall.Life_Count'Access,
          East => Board.Wall.Life_Count'Access,
          South_East => Board.Wall.Life_Count'Access,
          South => Board.Wall.Life_Count'Access,
          South_West => Board.Wall.Life_Count'Access,
          West =>
             Board.Grid (T_Rows'Last, T_Cols'Last - 1).Life_Count'Access,
          North_West =>
             Board.Grid
                (T_Rows'Last - 1, T_Cols'Last - 1).Life_Count'Access,
          North =>
             Board.Grid (T_Rows'Last - 1, T_Cols'Last).Life_Count'Access);

      --  fill the sides
      for Col in T_Cols range T_Cols'First + 1 .. T_Cols'Last - 1 loop
         Board.Grid (T_Rows'First, Col).Neighbour_Count :=
            (North_West => Board.Wall.Life_Count'Access,
             North => Board.Wall.Life_Count'Access,
             North_East => Board.Wall.Life_Count'Access,
             West =>
                Board.Grid (T_Rows'First, Col - 1).Life_Count'Access,
             East =>
                Board.Grid (T_Rows'First, Col + 1).Life_Count'Access,
             South_West =>
                Board.Grid (T_Rows'First + 1, Col - 1).Life_Count'Access,
             South =>
                Board.Grid (T_Rows'First + 1, Col).Life_Count'Access,
             South_East =>
                Board.Grid (T_Rows'First + 1, Col + 1).Life_Count'Access);
         Board.Grid (T_Rows'Last, Col).Neighbour_Count :=
            (South_West => Board.Wall.Life_Count'Access,
             South => Board.Wall.Life_Count'Access,
             South_East => Board.Wall.Life_Count'Access,
             West =>
                Board.Grid (T_Rows'Last, Col - 1).Life_Count'Access,
             East =>
                Board.Grid (T_Rows'Last, Col + 1).Life_Count'Access,
             North_West =>
                Board.Grid (T_Rows'Last - 1, Col - 1).Life_Count'Access,
             North =>
                Board.Grid (T_Rows'Last - 1, Col).Life_Count'Access,
             North_East =>
                Board.Grid (T_Rows'Last - 1, Col + 1).Life_Count'Access);
      end loop;
      for Row in T_Rows range T_Rows'First + 1 .. T_Rows'Last - 1 loop
         Board.Grid (Row, T_Cols'First).Neighbour_Count :=
            (North_West => Board.Wall.Life_Count'Access,
             West => Board.Wall.Life_Count'Access,
             South_West => Board.Wall.Life_Count'Access,
             North =>
                Board.Grid (Row - 1, T_Cols'First).Life_Count'Access,
             South =>
                Board.Grid (Row + 1, T_Cols'First).Life_Count'Access,
             South_East =>
                Board.Grid (Row + 1, T_Cols'First + 1).Life_Count'Access,
             East =>
                Board.Grid (Row, T_Cols'First + 1).Life_Count'Access,
             North_East =>
                Board.Grid (Row - 1, T_Cols'First + 1).Life_Count'Access);
         Board.Grid (Row, T_Cols'Last).Neighbour_Count :=
            (North_East => Board.Wall.Life_Count'Access,
             East => Board.Wall.Life_Count'Access,
             South_East => Board.Wall.Life_Count'Access,
             North =>
                Board.Grid (Row - 1, T_Cols'Last).Life_Count'Access,
             South =>
                Board.Grid (Row + 1, T_Cols'Last).Life_Count'Access,
             South_West =>
                Board.Grid (Row + 1, T_Cols'Last - 1).Life_Count'Access,
             West =>
                Board.Grid (Row, T_Cols'Last - 1).Life_Count'Access,
             North_West =>
                Board.Grid (Row - 1, T_Cols'Last - 1).Life_Count'Access);
      end loop;
      --  rest of the board, all cells have neighbours
      for Col in T_Cols range T_Cols'First + 1 .. T_Cols'Last - 1 loop
         for Row in T_Rows range T_Rows'First + 1 .. T_Rows'Last - 1 loop
            Board.Grid (Row, Col).Neighbour_Count :=
               (North_West =>
                   Board.Grid (Row - 1, Col - 1).Life_Count'Access,
                North =>
                   Board.Grid (Row - 1, Col).Life_Count'Access,
                North_East =>
                   Board.Grid (Row - 1, Col + 1).Life_Count'Access,
                West =>
                   Board.Grid (Row, Col - 1).Life_Count'Access,
                East =>
                   Board.Grid (Row, Col + 1).Life_Count'Access,
                South_West =>
                   Board.Grid (Row + 1, Col - 1).Life_Count'Access,
                South =>
                   Board.Grid (Row + 1, Col).Life_Count'Access,
                South_East =>
                   Board.Grid (Row + 1, Col + 1).Life_Count'Access);
         end loop;
      end loop;
   end Init_Links_Between_Cells;

   --  Set one cell of the board alive
   procedure Set_Cell_Alive (Board   : T_Board;
                             Row     : T_Rows;
                             Col     : T_Cols) is
   begin
      Board.Grid (Row, Col).Life_Count := 1;
   end Set_Cell_Alive;

   function Get_Empty_Cell return T_Cell is
   begin
      return (Life_Count => 0,
              Total_Neighbour_Count => 0,
              Neighbour_Count => (others => null));
   end Get_Empty_Cell;

   function Get_Empty_Board return T_Board is
      Empty_Board : constant T_Board :=
         new T_Board_Record'(
            Grid => (others =>
                        (others => Get_Empty_Cell)),
            Wall => Get_Empty_Cell);
   begin
      Init_Links_Between_Cells (Empty_Board);
      return Empty_Board;
   end Get_Empty_Board;

   procedure Tick (Board : T_Board) is
   begin
      --  Recount the neighbours
      Count_Neighbours (Board);
      --  Will the cells live or die
      for Col in T_Cols range T_Cols'First + 1 .. T_Cols'Last - 1 loop
         for Row in T_Rows range T_Rows'First + 1 .. T_Rows'Last - 1 loop
            Board.Grid (Row, Col).Life_Count :=
              (if Board.Grid (Row, Col).Total_Neighbour_Count = 2
                then Board.Grid (Row, Col).Life_Count
               elsif Board.Grid (Row, Col).Total_Neighbour_Count = 3
                 then 1
               else 0);
         end loop;
      end loop;
   end Tick;

   procedure Print_Board (Board : T_Board) is
   begin
      for Row in T_Rows loop
         for Col in T_Cols loop
            if Board.Grid (Row, Col).Life_Count = 1 then
               Put ("#");
            else
               Put (".");
            end if;
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Print_Board;

end Generic_Board;