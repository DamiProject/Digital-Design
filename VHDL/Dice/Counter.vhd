library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;


------------------------------------------------------------------------------------
-- This synchronous modulo-6 counter is reused twice in the complete design:
-- 1. As a 'random_counter' to generate the random dice roll.
-- 2. As an 'address_counter' to step through the memory locations.
-------------------------------------------------------------------------------------
entity Counter is
  port (  Reset  : in  std_logic;
          Clock  : in  std_logic;
          Enable : in  std_logic;
          Q      : out std_logic_vector(2 downto 0));
end entity Counter;


architecture Rtl of Counter is

  signal Count : unsigned(2 downto 0);

begin

  process(Clock, Reset)
  begin
    if Reset = '1' then
      Count <= "001";
    elsif rising_edge(Clock) then

      if Enable = '1' then
        if Count = "110" then
          Count <= "001";
        else
          Count <= Count + 1;
        end if;
      end if;

    end if;
  end process;

  Q <= std_logic_vector(Count);

end architecture Rtl;
