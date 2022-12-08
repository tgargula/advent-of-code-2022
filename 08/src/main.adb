with Text_IO; use Text_IO;

procedure Main is
   --  To adjust
   Step      : constant Natural := 2;
   X         : constant Natural := 99;
   Y         : constant Natural := 99;
   File_Name : constant String  := "./data/input.txt";

   type Board_Type is array (1 .. X, 1 .. Y) of Natural;
   type Visible_Type is array (1 .. X, 1 .. Y) of Boolean;

   --  For debugging
   procedure Print_Board (Board : Board_Type) is
   begin
      for I in 1 .. X loop
         for J in 1 .. Y loop
            Put (Integer'Image (Board (I, J)));
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Print_Board;

   --  For debugging
   procedure Print_Visible (Visible : Visible_Type) is
   begin
      for I in 1 .. X loop
         for J in 1 .. Y loop
            if Visible (I, J) then
               Put ("1");
            else
               Put ("0");
            end if;
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Print_Visible;

   function Read_File (File_Name : String) return Board_Type is
      F     : File_Type;
      Value : String (1 .. X);
      Board : Board_Type;
      I     : Natural := 1;
   begin
      Open (File => F, Mode => In_File, Name => File_Name);
      loop
         exit when End_Of_File (F);
         Get (F, Value);
         for J in 1 .. Y loop
            Board (I, J) := Natural'Value ((1 => Value (J)));
         end loop;
         I := I + 1;
      end loop;

      Close (F);
      return Board;
   end Read_File;

   function Get_Visible (Board : Board_Type) return Visible_Type is
      Visible : Visible_Type;
      Max     : Integer := -1;
   begin
      --  Initialize
      for I in 1 .. X loop
         for J in 1 .. Y loop
            Visible (I, J) := False;
         end loop;
      end loop;

      --  Left - Right
      for I in 1 .. X loop
         for J in 1 .. Y loop
            if Board (I, J) > Max then
               Visible (I, J) := True;
               Max            := Board (I, J);
            end if;
         end loop;
         Max := -1;
      end loop;

      --  Right - Left
      for I in 1 .. X loop
         for J in reverse 1 .. Y loop
            if Board (I, J) > Max then
               Visible (I, J) := True;
               Max            := Board (I, J);
            end if;
         end loop;
         Max := -1;
      end loop;

      --  Top - Bottom
      for J in 1 .. Y loop
         for I in 1 .. X loop
            if Board (I, J) > Max then
               Visible (I, J) := True;
               Max            := Board (I, J);
            end if;
         end loop;
         Max := -1;
      end loop;

      --  Bottom - Top
      for J in 1 .. Y loop
         for I in reverse 1 .. X loop
            if Board (I, J) > Max then
               Visible (I, J) := True;
               Max            := Board (I, J);
            end if;
         end loop;
         Max := -1;
      end loop;

      return Visible;
   end Get_Visible;

   function Get_Sum (Visible : Visible_Type) return Natural is
      Sum : Natural := 0;
   begin
      for I in 1 .. X loop
         for J in 1 .. Y loop
            if Visible (I, J) then
               Sum := Sum + 1;
            end if;
         end loop;
      end loop;

      return Sum;
   end Get_Sum;

   function Get_Space (Board : Board_Type) return Integer is
      Result : Board_Type;
      Up     : Natural := 0;
      Left   : Natural := 0;
      Bottom : Natural := 0;
      Right  : Natural := 0;
      Max    : Natural := 0;
   begin
      --  Initialize
      for I in 1 .. X loop
         for J in 1 .. Y loop
            Result (I, J) := 0;
         end loop;
      end loop;

      for I in 1 .. X loop
         for J in 1 .. Y loop
            --  Up
            for K in reverse 1 .. I - 1 loop
               Up := Up + 1;
               exit when Board (K, J) >= Board (I, J);
            end loop;

            --  Down
            for K in I + 1 .. X loop
               Bottom := Bottom + 1;
               exit when Board (K, J) >= Board (I, J);
            end loop;

            --  Left
            for K in reverse 1 .. J - 1 loop
               Left := Left + 1;
               exit when Board (I, K) >= Board (I, J);
            end loop;

            --  Right
            for K in J + 1 .. Y loop
               Right := Right + 1;
               exit when Board (I, K) >= Board (I, J);
            end loop;

            Result (I, J) := Up * Bottom * Right * Left;
            Up            := 0;
            Bottom        := 0;
            Right         := 0;
            Left          := 0;
         end loop;
      end loop;

      for I in 1 .. X loop
         for J in 1 .. Y loop
            if Result (I, J) > Max then
               Max := Result (I, J);
            end if;
         end loop;
      end loop;

      return Max;
   end Get_Space;

   Board   : Board_Type;
   Visible : Visible_Type;
   Sum     : Natural;
begin
   Board := Read_File (File_Name);

   if Step = 1 then
      Visible := Get_Visible (Board);

      Sum := Get_Sum (Visible);
      Put_Line (Integer'Image (Sum));
   end if;

   if Step = 2 then
      Sum := Get_Space (Board);
      Put (Integer'Image (Sum));
   end if;
end Main;
