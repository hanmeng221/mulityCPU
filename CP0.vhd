----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:43:09 03/19/2019 
-- Design Name: 
-- Module Name:    CP0 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CP0 is
    Port ( raddr_i : in  STD_LOGIC_VECTOR (4 downto 0);
           int_i : in  STD_LOGIC_VECTOR (5 downto 0);
           we_i : in  STD_LOGIC;
           waddr_i : in  STD_LOGIC_VECTOR (4 downto 0);
           wdata_i : in  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
           data_o : out  STD_LOGIC_VECTOR (31 downto 0);
           count_o : out  STD_LOGIC_VECTOR (31 downto 0);
           compare_o : out  STD_LOGIC_VECTOR (31 downto 0);
           status_o : out  STD_LOGIC_VECTOR (31 downto 0);
           cause_o : out  STD_LOGIC_VECTOR (31 downto 0);
           epc_o : out  STD_LOGIC_VECTOR (31 downto 0);
           config_o : out  STD_LOGIC_VECTOR (31 downto 0);
           prid_o : out  STD_LOGIC_VECTOR (31 downto 0);
           timer_int_o : out  STD_LOGIC);
end CP0;

architecture Behavioral of CP0 is

begin


end Behavioral;

