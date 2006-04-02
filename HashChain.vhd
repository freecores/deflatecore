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
    Port ( Hash_o   : out std_logic_vector (Hash_Width - 1 downto 0);     -- Hash value of previous data
           Data_in  : in  std_logic_vector (Data_Width-1 downto 0);       -- Data input from byte stream
			  Clock,													                    -- Clock
			  Reset,													                    -- Reset
			  Output_E : in  bit	;	                     						  -- Output Enable
           Hash_Generated : out bit													  -- Enabled when the hash key has been generated
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

mode <= 0 when clock = '1' and reset = '0' and Output_E = '1' and mode = 4 else  -- Active data being latched to output
        1 when clock = '0' and reset = '0' and Output_E = '1' and mode = 0 else  -- No change to output till thge next clock
		  2 when clock = '1' and reset = '0' and Output_E = '1' and mode = 1 else  -- Reset active
		  3 when clock = '0' and reset = '0' and Output_E = '1' and mode = 2 else  -- Reset active
		  4 when clock = '1' and reset = '0' and Output_E = '1' and mode = 3 else  -- Disable output
 		  -- Synchronous reset
		  -- Remove remark and semi colon from 8 but it results in greater resource utilisation
		  8 when clock ='1' and reset ='1';													

Hash_Generated <= '0' when mode <4 or mode = 8 else
						'1';

Process (clock)
variable a, b, hash :std_logic_vector (Hash_Width - 1 downto 0); -- Variables for calculating the output
variable hashg:bit;
begin
case mode is 
when 0 =>                                                            --Calculate the hash key of the current input value using the Data on the input vector
	b := b + Data_in;																	--Store the input value into a variable
when 1 =>
	a := hash * X"21";		                                          --Multiply the hash value by 33 
when 2 =>
 	tempval <= a+hash;
when 3 =>																					-- 
	hash := tempval xor b;    													   --Xor the above value to the previous hashkey to generate the new hash key
when 4 =>
	b := X"00000000";
when others=>								 
   hash := X"16c7";																	--Reset initial hash value to 5831  
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

