----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:24:21 01/12/2017 
-- Design Name: 
-- Module Name:    ssss - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
port(
			CLK : in  STD_LOGIC;
			P1 : in STD_LOGIC;
			P2 : in STD_LOGIC;
			P3 : in STD_LOGIC;
			P4 : in STD_LOGIC;
			P5 : in STD_LOGIC;
			P6 : in STD_LOGIC;
			P7 : in STD_LOGIC;
			P8 : in STD_LOGIC;
         VS : out  STD_LOGIC;
         HS : out  STD_LOGIC;
         R : out  STD_LOGIC;
         G : out  STD_LOGIC;
			B : out  STD_LOGIC);
			
			
end VGA;

architecture Behavioral of VGA is

signal flag : STD_LOGIC; 
signal CLK25Mhz : STD_LOGIC;
signal CLK_MOV : STD_LOGIC;
begin



process(CLK)


		begin
			if CLK'event and CLK = '1' then
				if CLK25Mhz = '0' then
					CLK25Mhz <= '1';
					
				else
					CLK25Mhz <= '0';
				end if;
			end if;
			
end process;

process(CLK)
variable counter : integer;
	begin
		if CLK'event and CLK = '1' then 
			counter := counter + 1;
			if counter = 250001 then
				CLK_MOV  <= not CLK_MOV;
				counter:=0;
			end if;
		end if;
end process;



process(CLK25Mhz, CLK_MOV)
variable poz_x : integer; 
variable poz_y : integer;
variable radius : integer; --circle radius[px]
variable x0 : integer; --circle center x
variable y0 : integer; --circle center y
begin
	if rising_edge(CLK_MOV) then
		if x0 = 0 then --initial circle position x
			x0 := 190;	
		end if; 
		if y0 = 0 then --initial circle position y
			y0 := 90;	
		end if; 
		if radius = 0 then --init radius
			radius:= 10;	
		end if; 
		
		if (P4='1' and  P5 = '0') then --move to the right
			x0 := x0 + 1;
			if x0 = 784 then --if out of visible area to the right
				x0 := 144;  -- got to left side
			end if;
		end if;
		if (P4 = '0' and P5 = '1') then --move to the left
			x0 := x0 - 1;
			if x0 = 144 then--if out of visible area to the left
				x0 := 784; -- go to right side
			end if;
		end if;
		if (P6='1' and  P7 = '0') then --move down
			y0 := y0 + 1;
			if y0 = 519 then
				y0 := 39;
			end if;
		end if;
		if (P6 = '0' and P7 = '1') then --move up
			y0 := y0 - 1;
			if y0 = 39 then
				y0 := 519;
			end if;
		end if;
		if (P8 = '1') then --circle resize
			if radius >= 80 then --if max size
				flag<= '1'; -- go down
			elsif radius<10 then --if min size
				flag<='0'; --go up
			end if;
			if flag = '0' then
				radius := radius + 1;
			else radius:=radius-1;
			end if;
		end if;	
	end if;

	
	if rising_edge(CLK25Mhz) then -- if next pixel
		if (poz_x >= 144) and (poz_x < 784) and (poz_y >= 39) and (poz_y < 519) then --if in visible part of the screen
			if ((radius*radius) >= ((poz_x-x0)*(poz_x-x0) + (poz_y - y0)*(poz_y- y0))) then --if its circle
				R <= P1; --set colors according to the switch'es
				G <= P2;
				B <= P3;
			else --its background(black)
				R <= '0';
				G <= '0';
				B <= '0';
			end if;
		end if;
		
		if (poz_x > 0 ) and (poz_x < 97) then 
			HS <= '0';
		else
			HS <= '1';
		end if;
		
		if (poz_y > 0 ) and (poz_y < 3) then
			VS <= '0';
		else
			VS <= '1';
		end if;
		poz_x := poz_x + 1;
	
		if (poz_x = 800) then --if horizontal end of screen
			poz_y := poz_y + 1; --  next row
			poz_x := 0; --column 0
		end if;
		if (poz_y = 521) then --if vertical end of screen
			poz_y := 0; -- new frame
		end if;	
	end if;
end process;

end Behavioral;

