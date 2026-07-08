-- Copyright    : ALSE - http://alse-fr.com
-- Contact      : info@alse-fr.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dice_pkg.all;
use work.apb_pkg.all;

-----------------------------------------------------------------------------------
-- This is a behavioral model of a memory, 
-- storing the alphabets of each rolled value.
-- The memory uses only AMBA APB interface to communicate to the rest of the system.
------------------------------------------------------------------------------------
entity apb_mem is
port (reset, pclk, penable, psel, pwrite : in std_logic;
      paddr  : in  apb_addr;
      pwdata : in  apb_data;
      prdata : out apb_data;
      pready : out std_logic);
end apb_mem;

architecture behav of apb_mem is
  type memT is array (natural range <>) of segmentsT;
  
  function init_mem return memT is
    constant dash   : std_logic_vector := "0000001";
    constant dashes : memT(1 to 8) := (others => dash);
    
    variable mem : memT(0 to 8*8-1);
    
  begin
    -- Unused slots zero and seven.
    mem(0*8 to 1*8-1) := dashes;
    mem(7*8 to 8*8-1) := dashes;
      
    -- One    
    mem(1*8 to 2*8-1) :=
      ( dash, "0011101", "0010101", "1001111", "0000000", "0000000", dash, dash);
      
    -- Two
    mem(2*8 to 3*8-1) :=
      ( dash, "0001111", "0011100", "0011000", "0011101", "0000000", dash, dash);
      
    -- Three
    mem(3*8 to 4*8-1) :=
      ( dash, "0001111", "0010111", "0000101", "1001111", "1001111", dash, dash);
      
    -- Four
    mem(4*8 to 5*8-1) :=
      ( dash, "1000111", "0011101", "0011100", "0000101", "0000000", dash, dash);
      
    -- Five
    mem(5*8 to 6*8-1) :=
      ( dash, "1000111", "0000110", "0111110", "1001111", "0000000", dash, dash);
      
    -- Six
    mem(6*8 to 7*8-1) :=
      ( dash, "1011011", "0000110", "1111000", "0000001", "1001110", dash, dash);
    
    return mem;
        
  end function init_mem;
  
  constant mem : memT(0 to 8*8-1) := init_mem;
  
  procedure check01(s : std_logic; msg : string) is
  begin
    assert s = '1' or s = '0' report "Nonsense on " & msg severity error;
  end procedure check01;
  
  procedure check01(s : std_logic_vector; msg : string) is
  begin
    for i in s'range loop
      check01(s(i), msg);
    end loop;
  end procedure check01;
  
begin

  pready <= '1';

  process
    constant settling_time : time := 1 ns;
    variable last_addr : apb_addr;
    
  begin
    
    wait until rising_edge(pclk);
    wait for settling_time;
    prdata <= (others => 'X');
    check01(penable, "penable");
    if penable = '0' then
      assert pwrite = '0'
        report "pwrite must be set to 0"
        severity error;
      assert psel = '1'
        report "psel is set to 0 but this is the only APB subordinate"
        severity error;
      check01(paddr, "paddr");
      last_addr := paddr;
    
      wait until rising_edge(pclk);
      wait for settling_time;
      assert paddr = last_addr
        report "paddr has changed between first and second APB cycles"
        severity error;
      assert psel = '1'
        report "psel has changed between first and second APB cycles"
        severity error;
      assert penable = '1'
        report "penable is not set to 1 on the second APB cycle"
        severity error;
      assert pwrite = '0'
        report "pwrite has changed between first and second APB cycles"
        severity error;
      
      prdata <= '0' & mem(to_integer(unsigned(paddr)));
    end if;
  end process;
  
end architecture behav;
