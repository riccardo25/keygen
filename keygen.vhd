library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keygen is


port(
	CLK, rst_n		: in std_logic;
	--key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	ROUND				: in std_logic_vector( 3 downto 0);
	
	valid				: out std_logic--;
	--data_out 		: out std_logic_vector( 127 downto 0)
);


end keygen;

architecture arc of keygen is

component key_interface is

port(
	CLK, rst_n		: in std_logic;
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	ROUND				: in std_logic_vector( 3 downto 0);
	curr_round		: in std_logic_vector( 3 downto 0);
	data_from_store: in std_logic_vector( 127 downto 0);
	reset				: out std_logic;
	valid				: out std_logic;
	data_out 		: out std_logic_vector( 127 downto 0)
);
end component;

signal data_from_store: std_logic_vector( 127 downto 0);
signal reset : std_logic;
signal curr_round : std_logic_vector( 3 downto 0);

signal key				:  std_logic_vector( 255 downto 0);
signal data_out 		:  std_logic_vector( 127 downto 0);

begin

INTERFACE: key_interface port map( 	CLK => CLK, rst_n => rst_n,
												key => key,
												key_len => key_len,
												ROUND => ROUND,
												curr_round => curr_round,
												data_from_store => data_from_store,
												reset	=> reset,
												valid	=> valid,
												data_out => data_out
											);
end arc;

