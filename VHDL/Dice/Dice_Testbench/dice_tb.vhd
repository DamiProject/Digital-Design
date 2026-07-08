-- Copyright    : ALSE - http://alse-fr.com
-- Contact      : info@alse-fr.com

----------------------------------------------------
-- Constrained-Random Testbench For the Hierarchical 
-- Design of the Dice Device
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.dice_pkg.all;
use work.dice_tb_pkg.all;
use std.textio.all;
use ieee.math_real.all;

entity dice_tb is
end entity dice_tb;

architecture behav of dice_tb is

  function zero_segments return all_segmentsT is
    variable results : all_segmentsT;
  begin
    for i in character_range loop
      for j in segment_range loop
        results(i, j) := '1';
      end loop;
    end loop;
    return results;
  end function zero_segments;
  
  constant dummy : boolean := false;
  
  constant clock_period  : time := 10 ns;
   
  signal segments : all_segmentsT:= zero_segments;
  signal clk, reset, roll, valid : std_logic;
  signal stop : boolean;
  
begin

  UUT : entity work.dice(RTL)
        port map (clk      => clk,
                  reset    => reset,
                  roll     => roll,
                  valid    => valid,
                  segments => segments);

  stim : process
    variable s1, s2 : positive := 100;
    variable rand : real;
    variable wait_period : integer;
  begin
    roll <= '0';
    reset <= '1';
    wait until rising_edge(clk);
    wait until falling_edge(clk);
    reset <= '0';
    for i in 1 to 6 loop
      uniform(s1, s2, rand);
      wait_period := integer(floor((10.0*rand)));
      for i in 1 to wait_period loop
        wait until falling_edge(clk);
      end loop;
      report "Rolling...";
      roll <= '1';
      wait until falling_edge(clk);
      roll <= '0';
      while valid /= '1' loop
        wait until falling_edge(clk);
      end loop;
      blank_line;      
      draw_x_all(segments, 0);
      draw_y_all(segments, 5, 1);
      draw_x_all(segments, 6);
      draw_y_all(segments, 4, 2);
      draw_x_all(segments, 3);
      blank_line;      
    end loop;
    stop <= TRUE;
    wait;
  end process stim;



clk_gen : process
  begin
    clk <= '0';
    while not stop loop
      wait for clock_period / 2;
      clk <= not clk;
    end loop;
    wait;
  end process clk_gen; 
end architecture behav;
