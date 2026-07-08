-- Copyright    : ALSE - http://alse-fr.com
-- Contact      : info@alse-fr.com

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------
-- This package defines the custom data types and array structures required
-- to map numeric dice roll values (1 to 6) into word representations and 
-- seven-segment display properties.
-----------------------------------------------------------------------------


package dice_pkg is

  subtype segment_range   is integer range 0 to 6;
  subtype character_range is integer range 1 to 5;

  subtype segmentsT is std_logic_vector(segment_range);
  
  type all_segments_vectorT is array (character_range) of segmentsT;

  type all_segmentsT is array (character_range, 
                               segment_range) of std_logic;

end package dice_pkg;