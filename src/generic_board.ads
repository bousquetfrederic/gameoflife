--  define a generic package -----------------------
--  the generic parameters are the size of the board
generic
   Nb_rows : Positive;
   Nb_cols : Positive;
package Generic_Board is

   type T_Rows is new Positive range 1 .. Nb_rows;
   type T_Cols is new Positive range 1 .. Nb_cols;
   type T_Board is limited private;

   --  When creating a new board, call this function
   --  to get a board ready to play (but empty)
   function Get_Empty_Board return T_Board;

   --  Use this procedure to turn one cell of the
   --  board alive (before starting the game)
   procedure Set_Cell_Alive (Board   : T_Board;
                             Row     : T_Rows;
                             Col     : T_Cols);

   --  Update the life status of all the cells once
   procedure Tick (Board : T_Board);

   --  Display the board
   procedure Print_Board (Board : T_Board);

private

   --  0 is dead, 1 is alive
   subtype T_Life_Count is Integer range 0 .. 1;

   --  Each cell will have a pointer pointing at each
   --  of its neighbours. It take time to setup at the
   --  beginning but it's done only once.
   type T_Neighbours is (North_West, North, North_East,
                         West, East,
                         South_West, South, South_East);

   --  An array to store the pointers to the 8 neighbours
   --  of each cell.
   type T_Ref_Count_Array is array (T_Neighbours)
                                of access constant T_Life_Count;

   --  Life count tells if the cell is alive or dead
   --  Total neighbours count sums the life count of
   --  each neighbours (easy with the pointers).
   --  Neigbour count holds the pointers to the 8
   --  neigbours.
   type T_Cell is
      record
         Life_Count : aliased T_Life_Count;
         Total_Neighbour_Count : Integer range 0 .. 8;
         Neighbour_Count : T_Ref_Count_Array;
      end record;

   type T_Grid is array (T_Rows, T_Cols) of T_Cell;

   --  The board is a grid of Row x Cols cells.
   --  There is a special empty cell which is used to
   --  represent the boundaries. For example, a cell
   --  of the first column does not have a western
   --  neighbour (it's the wall) so we make the pointer
   --  to its western neighbours point to the special
   --  empty cell, which remains dead all the time.
   --  (see procedure Init_Links_Between_Cells)
   type T_Board_Record is
      record
         Grid : T_Grid;
         Empty_Cell : aliased T_Cell;
      end record;

   type T_Board is access T_Board_Record;

end Generic_Board;