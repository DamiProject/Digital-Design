-- Copyright    : ALSE - http://alse-fr.com
-- Contact      : info@alse-fr.com
library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------------------------------
-- This package contains AMBA APB custom definitions such as datatype, 
-- address, and data width for both manager and subordinates.
-----------------------------------------------------------------------
package apb_pkg is

  constant apb_data_width : integer := 8;
  constant apb_addr_width : integer := 8;

  subtype apb_data is std_logic_vector(apb_data_width-1 downto 0);
  subtype apb_addr is std_logic_vector(apb_addr_width-1 downto 0);

end package apb_pkg;