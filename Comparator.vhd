-------------------------------------------------------------------------------
--
-- Title       : Comparator
-- Design      : Cache_2_Way
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : Comparator.vhd
-- Generated   : Mon Jan 31 01:02:52 2022
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Comparator} architecture {Comparator}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Comparator is
generic (
		Length	: integer := 3  -- LENGTH OF INPUT DATA
	); 	   
	
	port (
	data_one: in std_logic_vector(Length-1 downto 0);
	data_two: in std_logic_vector(Length-1 downto 0);
	
	F		: out std_logic
	);
end Comparator;

--}} End of automatically maintained section

architecture Comparator of Comparator is
signal xnor_results: std_logic_vector (Length -1 downto 0);
begin
	
	xnor_generator: 
	for i in Length -1 downto 0 generate
		xnor_results(i) <= data_one(i) xnor data_two(i);
	end generate xnor_generator;  
	
	

	F <= xnor_results(0) and xnor_results(1) and xnor_results(2);

end Comparator;
