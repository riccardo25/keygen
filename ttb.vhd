LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ttb IS
END ttb;
 
ARCHITECTURE behavior OF ttb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component generator is
		port(
			CLK, rst_n : in std_logic;
			
			-- INPUT
			--key : in std_logic_vector (255 downto 0);
			key_len : in std_logic_vector (1 downto 0); 
			ROUND : in std_logic_vector (3 downto 0);
			
			valid : out std_logic;
			w0_new: out std_logic_vector (31 downto 0);
			-- OUTPUT
			curr_round : out std_logic_vector (3 downto 0);
			dataround: out std_logic_vector (127 downto 0)
		);

		end component;
    

   --Inputs
   signal CLK : std_logic := '0';
	signal valid : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal key : std_logic_vector(255 downto 0) := (others => '0');
   signal key_len : std_logic_vector(1 downto 0) := (others => '0');
   signal ROUND : std_logic_vector(3 downto 0) := (others => '0');
	signal w0_new: std_logic_vector (31 downto 0);

 	--Outputs
   signal curr_round : std_logic_vector(3 downto 0);
   signal dataround : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: generator PORT MAP (
          CLK => CLK,
          rst_n => rst_n,
          --key => key,
			 w0_new=> w0_new,
          key_len => key_len,
			 valid => valid,
          ROUND => ROUND,
          curr_round => curr_round,
          dataround => dataround
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period;
		rst_n <='1';
		key <= X"00000000000000000000000000000000" & X"09cf4f3c" & X"abf71588" & X"28aed2a6"& X"2b7e1516";

      -- insert stimulus here 

      wait;
   end process;

END;
