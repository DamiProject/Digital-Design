-- Copyright    : ALSE - http://alse-fr.com
-- Contact      : info@alse-fr.com
----------------------------------------------------------------------
-- This package contains custom definitions procedures used to format
-- testbench output.
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.dice_pkg.all;

package dice_tb_pkg is
  
procedure draw_x_all(segments : all_segmentsT;
                     i : segment_range);
                     
procedure draw_y_all(segments : all_segmentsT;
                     i : segment_range;
                     j : segment_range);
                     
procedure blank_line;

end package dice_tb_pkg;


use std.textio.all;

package body dice_tb_pkg is

type linesT is array (std_logic'('0') to std_logic'('1')) of string(1 to 8);
constant lines : linesT := ( "        ", "####### ");

type dotT is array (std_logic'('0') to std_logic'('1')) of character;
constant dot : dotT := ( ' ', '#');

procedure blank_line is
  variable l : line;
begin
  writeline(output,l);
end procedure;

procedure draw_x_all(segments : all_segmentsT;
                     i : segment_range) is
  variable l : line;
begin
  write(l, string'("  "));
  for s in character_range loop
    write(l, lines(segments(s, i)));
  end loop;
  writeline(output, l);
end procedure draw_x_all;

procedure draw_y_all(segments : all_segmentsT;
                     i : segment_range;
                     j : segment_range) is
  variable l : line;
begin

  for n in 1 to 2 loop
    write(l, string'("  "));
    for s in character_range loop
      write(l, dot(segments(s, i)));
      write(l, string'("     "));
      write(l, dot(segments(s, j)));
      write(l, string'(" "));
    end loop;
    writeline(output, l);
  end loop;
end procedure draw_y_all;

end package body dice_tb_pkg;
