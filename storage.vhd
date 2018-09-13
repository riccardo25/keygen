library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity storage is

port(
	CLK, rst_n : in std_logic;
	
	-- INPUT
	key : in std_logic_vector (255 downto 0);
	key_len : in std_logic_vector (1 downto 0); 
	ROUND : in std_logic_vector (3 downto 0);
	
	
	
	-- OUTPUT 2
	data_from_store : out std_logic_vector (127 downto 0)
);
end storage;

architecture arc of storage is

begin


end arc;

