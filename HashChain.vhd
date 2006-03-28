--------------------------------------------------------------------------------
-- Create Date:    03:46:54 10/31/05
-- Design Name:    
-- Module Name:    Hash - Behavioral
-- Project Name:   Deflate
-- Revision:
-- Revision 0.02 - File Created
-- Additional Comments:
-- 3 Hashing algorithms with the same interface.
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
    Port ( Hash_o   : out std_logic_vector (Hash_Width - 1 downto 0);     -- Hash value of previous data
           Data_in  : in  std_logic_vector (Data_Width-1 downto 0);       -- Data input from byte stream
			  Clock,													                    -- Clock
			  Reset,													                    -- Reset
			  Output_E : in  bit		                     						  -- Output Enable
           );
end HashChain;
 
--An algorithm produced by Professor Daniel J. Bernstein and 
--shown first to the world on the usenet newsgroup comp.lang.c. 
--It is one of the most efficient hash functions ever published
--Actual function hash(i) = hash(i - 1) * 33 + str[i];
--Function now implemented using XOR hash(i) = hash(i - 1) * 33 ^ str[i];
architecture DJB2 of HashChain is
signal mode: integer;
signal tempval:std_logic_vector (Hash_Width - 1 downto 0);
begin
mode <= 0 when clock = '1' and reset = '0' and Output_E = '1' else  -- Active data being latched to output
        1 when clock = '0' and reset = '0' and Output_E = '1' else  -- No change to output till thge next clock
		  2 when clock = '1' and reset = '1' and Output_E = '1' else  -- Reset active
		  2 when clock = '1' and reset = '1' and Output_E = '0' else  -- Reset active
		  3 when clock = '1' and reset = '0' and Output_E = '0' else  -- Disable output
		  4;

Process (mode)
variable a, b, hash :std_logic_vector (Hash_Width - 1 downto 0); -- Variables for calculating the output
begin
case mode is 
when 0 =>                                                            --Calculate the hash key of the current input value using the Data on the input vector
	a := hash * X"21";		                                          --Multiply the hash value by 33 
	b := X"00000000";
	b := b + Data_in;
   tempval <= a+hash;
	hash := tempval xor b;    													--Add the above value to the previous hash and add the input data
when 2 =>																				--Reset
    hash := X"16c7";																	--Reset initial hash value to 5831  
when 3=>																					-- Need to implement a disable output section

when OTHERS =>																			-- Do nothing 

End case;
hash_o<= hash;																			-- Latch the clculated hash value to the output
end process;
end DJB2;
--Configuration:
--Assign the name of the algorithm as the configuration.

--Configuration rs_hash of hashchain is 
--for rshash
--end for;
--end rs_hash;

--Configuration djb_hash of hashchain is 
--for djb
--end for;
--end djb_hash;

Configuration djb2_hash of hashchain is 
for djb2
end for;
end djb2_hash;

--Configuration sdbm_hash of hashchain is 
--for sdbm
--end for;
--end sdbm_hash;

