library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_interface is

port(
	CLK, rst_n		: in std_logic;
	
	--INPUT
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	ROUND				: in std_logic_vector( 3 downto 0);
	curr_round		: in std_logic_vector( 3 downto 0);
	data_from_store: in std_logic_vector( 127 downto 0);
	
	
	
	--OUTPUT
	reset				: out std_logic;
	valid				: out std_logic;
	data_out 		: out std_logic_vector( 127 downto 0)
);
end key_interface;

architecture arc of key_interface is

component key_int_datapath is
port(
	CLK, rst_n		: in std_logic;
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);	
	sel_key, sel_len, load_key, load_len : in std_logic;
	key_len_out		: out std_logic_vector( 1 downto 0);
	key_out			: out std_logic_vector( 255 downto 0)
);
end component;

component key_int_contr is
port(
	CLK, rst_n		: in std_logic;
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	key_dp			: in std_logic_vector( 255 downto 0); --from datapath
	key_len_dp		: in std_logic_vector( 1 downto 0); --from datapath
	ROUND				: in std_logic_vector( 3 downto 0);
	curr_round		: in std_logic_vector( 3 downto 0);
	sel_key, sel_len, load_key, load_len : out std_logic;
	reset				: out std_logic;
	valid				: out std_logic
);
end component;


signal sel_key, sel_len, load_key, load_len : std_logic;
signal key_dp : std_logic_vector( 255 downto 0);
signal key_len_dp : std_logic_vector( 1 downto 0);

begin

	DP		: key_int_datapath port map(CLK => CLK, rst_n => rst_n, 
											key => key,
											key_len => key_len,
											sel_key => sel_key, sel_len => sel_len, 
											load_key => load_key, load_len => load_len,
											key_len_out	=> key_len_dp,
											key_out	=> key_dp);
											
	CONTR	: key_int_contr port map(CLK => CLK, rst_n => rst_n, 
											key => key,
											key_len => key_len,
											key_dp => key_dp,
											key_len_dp => key_len_dp,
											ROUND	=> ROUND,
											curr_round => curr_round,
											sel_key => sel_key, sel_len => sel_len, 
											load_key => load_key, load_len => load_len,
											reset => reset,
											valid	=> valid);
	data_out <= data_from_store;

end arc;

