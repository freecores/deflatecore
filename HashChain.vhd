--------------------------------------------------------------------------------
-- Create Date:    03:46:54 10/31/05
-- Design Name:    
-- Module Name:    Hash - Behavioral
-- Project Name:   Deflate
-- Revision:
-- Revision 0.25 - Only one hash algorithm
-- Additional Comments:
-- The remarked comments for synchronous reser result in the use of more 192 slices witn a maximum frequency of 129 Mhz
--	But if the code is commented as it is now the number of slices utlised is 5 without a known clock , need to specifiy that as a compile time constraint.
-- TO DO: 
-- Wishbone interface
-- Concurrent Hashkey generation
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_unsigned.all; 

entity HashChain is
    Generic
	      (																					  -- Data bus width currently set at 8
			 Data_Width : natural := 8;												  -- Width of the hash key generated now at 32 bits
			 Hash_Width : natural := 32
         );
    Port ( Hash_O   : inout std_logic_vector (Hash_Width - 1 downto 0);     -- Hash value of previous data
           Data_in  : in  std_logic_vector (Data_Width-1 downto 0);       -- Data input from byte stream
			  Clock,													                    -- Clock
			  Reset,
			  Star_t,													                    -- Reset
			  O_E : in  bit	;	                     						     -- Output Enable
           Busy,
			  Done : out bit													           -- Enabled when the hash key has been generated
			  );
end HashChain;
 
--An algorithm produced by Professor Daniel J. Bernstein and 
--shown first to the world on the usenet newsgroup comp.lang.c. 
--It is one of the most efficient hash functions ever published
--Actual function hash(i) = hash(i - 1) * 33 + str[i];
--Function now implemented using XOR hash(i) = hash(i - 1) * 33 ^ str[i];
architecture DJB2 of HashChain is
signal mode: integer;
signal tempval, hash :std_logic_vector (Hash_Width - 1 downto 0);
begin

mode <= 0 when (Reset = '1' or  mode  > 4) and clock = '1' else                                    -- Rezet
        1 when Star_t = '1' and (mode = 0 or mode < 5) and clock ='1' else        -- Start key generation
		  2 when mode  =  1  and clock = '0' else                                      -- Just the rest of the statemachine
		  3 when mode  =  2  and clock = '1' else 
		  4 when mode  =  3  and clock = '0' and O_E = '1' else
		  5 ;  

hash <= X"16c7"  when mode = 0 else
		  --hash sll 5  when mode = 1 else
		  hash xor tempval when mode =3 else
		  hash;

tempval <= X"0000" when mode /= 2 else
           tempval+ Data_in;

busy <= '1' when mode > 0 and mode <3 else
        '0';

Hash_O <= hash when mode =3 else
          Hash_O when (mode = 4 or mode = 5) and O_E = '1' else
			 X"0000";

done <= '1' when mode = 3 else
        '0';


end DJB2;

Configuration djb2_hash of hashchain is 
for djb2
end for;
end djb2_hash;
