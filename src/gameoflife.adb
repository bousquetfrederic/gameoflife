with Ada.Text_IO; use Ada.Text_IO;
with Generic_Board;

procedure Gameoflife is

--  Main program --------------------------------
begin
   Put_Line ("The Game of Life");
   declare
      package P_Board is new Generic_Board (Nb_Rows => 20, Nb_Cols => 20);
      My_Board : constant P_Board.T_Board := P_Board.Get_Empty_Board;
   begin
      --  starting board
      P_Board.Set_Cell_Alive (My_Board, 5, 6);
      P_Board.Set_Cell_Alive (My_Board, 6, 7);
      P_Board.Set_Cell_Alive (My_Board, 7, 7);
      P_Board.Set_Cell_Alive (My_Board, 7, 6);
      P_Board.Set_Cell_Alive (My_Board, 7, 5);
      P_Board.Print_Board (My_Board);

      for I in 1 .. 2 loop
         P_Board.Tick (My_Board);
         P_Board.Print_Board (My_Board);
      end loop;

   end;
end Gameoflife;
