--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- Create Date:    03:46:54 10/31/05
-- Design Name:    
-- Module Name:    Hash - Behavioral
-- Project Name:   Deflate
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_unsigned.all;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HashChain is
    Port ( Data_in  : in std_logic_vector (7 downto 0);   -- Data input from byte stream
           Hash_o   : out real;                          -- Hash value of previous data
           Clock,													   -- Clock
			  Reset,													   -- Reset
			  Output_E : in bit									   -- Output Enable
           );
end HashChain;


--From Robert Sedgwicks Algorithms in C
architecture RSHash of HashChain is
signal mode,
       data : integer;

begin
mode <= 0 when clock = '1' and reset = '0' and Output_E = '1' else  -- Active data being latched to output
        1 when clock = '0' and reset = '0' and Output_E = '1' else  -- No change to output till thge next clock
		  2 when clock = '1' and reset = '1' and Output_E = '1' else  -- Reset active
		  2 when clock = '1' and reset = '1' and Output_E = '0' else  -- Reset active
		  3 when clock = '1' and reset = '0' and Output_E = '0' else  -- Disable output
		  4;
--data <= Data_in; --Need to convert the input standard logic input to a form that can be processed using arthimetic
Process (mode)
variable a, b, hash : real ; -- Variables for calculating the output
begin
case mode is 
when 0 =>                    --Calculate the hash key of the current input value using the Data on the input vector
   hash := hash * a;
   hash := hash + data;
	a    := a * b;
when 2 =>
    hash := 0.0;					-- Reset 
	 a:=378551.0;					-- Reset 
	 b:=63689.0;					-- Reset
when 3=>								-- Need to implement a disable output section

when OTHERS =>						-- Do nothing 

End case;
hash_o<= hash;						-- Assign the clculated hash value to the output
end process;
end RSHash;

--An algorithm produced by Professor Daniel J. Bernstein and 
--shown first to the world on the usenet newsgroup comp.lang.c. 
--It is one of the most efficient hash functions ever published
--Actual function hash(i) = hash(i - 1) * 33 + str[i];
--Function now implemented using XOR hash(i) = hash(i - 1) * 33 ^ str[i];
architecture DJB of HashChain is
signal mode,
       data : integer;

begin
mode <= 0 when clock = '1' and reset = '0' and Output_E = '1' else  -- Active data being latched to output
        1 when clock = '0' and reset = '0' and Output_E = '1' else  -- No change to output till thge next clock
		  2 when clock = '1' and reset = '1' and Output_E = '1' else  -- Reset active
		  2 when clock = '1' and reset = '1' and Output_E = '0' else  -- Reset active
		  3 when clock = '1' and reset = '0' and Output_E = '0' else  -- Disable output
		  4;
--data <= Data_in; --Need to convert the input standard logic input to a form that can be processed using arthimetic
Process (mode)
variable a, b, hash : real ; -- Variables for calculating the output
begin
case mode is 
when 0 =>                    --Calculate the hash key of the current input value using the Data on the input vector
	a := hash * 33.0;
   hash := a + hash + data; 
when 2 =>
    hash := 5831.0;				-- Reset 
when 3=>								-- Need to implement a disable output section

when OTHERS =>						-- Do nothing 

End case;
hash_o<= hash;						-- Assign the clculated hash value to the output
end process;
end DJB;


--This algorithm was created for sdbm (a public-domain reimplementation of ndbm) database library.
--it was found to do well in scrambling bits, causing better distribution of the keys and fewer splits.
--it also happens to be a good general hashing function with good distribution. 
--the actual function is hash(i) = hash(i - 1) * 65599 + str[i];
architecture sdbm of HashChain is
signal mode,
       data : integer;

begin
mode <= 0 when clock = '1' and reset = '0' and Output_E = '1' else  -- Active data being latched to output
        1 when clock = '0' and reset = '0' and Output_E = '1' else  -- No change to output till thge next clock
		  2 when clock = '1' and reset = '1' and Output_E = '1' else  -- Reset active
		  2 when clock = '1' and reset = '1' and Output_E = '0' else  -- Reset active
		  3 when clock = '1' and reset = '0' and Output_E = '0' else  -- Disable output
		  4;
--data <= Data_in;           --Need to convert the input standard logic input to a form that can be processed using arthimetic
Process (mode)
variable a, b, hash : real ; -- Variables for calculating the output
begin
case mode is 
when 0 =>                    --Calculate the hash key of the current input value using the Data on the input vector
	a := hash * 65599.0;
   hash := a + hash + data; 
when 2 =>
    hash := 0.0;				      -- Reset 
when 3=>								-- Need to implement a disable output section

when OTHERS =>						-- Do nothing 

End case;
hash_o<= hash;						-- Assign the clculated hash value to the output
end process;
end sdbm;